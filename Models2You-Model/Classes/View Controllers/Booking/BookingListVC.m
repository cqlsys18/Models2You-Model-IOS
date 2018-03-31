//
//  BookingListVC.m
//  Models2You-Model
//
//  Created by user on 9/17/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BookingListVC.h"

#import "BookingDetailVC.h"
#import "SVProgressHUD.h"
#import "WebServiceClient.h"
#import "NSDate+Custom.h"
#import "BookingListCell.h"
#import "Utils.h"

#import "DisplayToast.h"

@interface BookingListVC ()

@property (nonatomic, strong) NSMutableArray *arrBookings;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation BookingListVC

@synthesize arrBookings, dateFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self initData];
    
    // Update booking list on notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBookingAppointmentCompleteNotification:) name:BOOKING_APPOINTMENT_COMPLETE_CANCEL object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [self initData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Notification
- (void) receiveBookingAppointmentCompleteNotification:(NSNotification *) notification{
    
    UIViewController *vc = [[self.navigationController viewControllers] lastObject];
    bool isViewControllerVisible = false;
    if(vc == self){
        isViewControllerVisible = true;
    }
    
    // refresh booking list
    if(self.bookingCat == CURRENT && isViewControllerVisible){
        [self initData];
    }
}

#pragma mark - Init

- (void)initData {
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a "];
    
    [self loadData];
}

- (void)loadData {
    
    [[DisplayToast sharedManager] showWithStatus:@"Loading..."];
    
    if(arrBookings){
        [arrBookings removeAllObjects];
        arrBookings = nil;
    }
    
    arrBookings = [NSMutableArray array];
    
    NSArray *bookingTypes;
    
    switch (self.bookingCat) {
            case CURRENT:
            case PAST:
            bookingTypes = @[@(ACCEPTED)];
            break;
            
            case PENDING:
            bookingTypes = @[@(BOOKED)];
            break;
        case CANCEL:
            bookingTypes = @[@(CANCELED), @(DENIED)];
            break;
            
        default:
            bookingTypes = @[@(COMPLETED)];
            break;
    }
    
    [[WebServiceClient sharedClient] listBookingsOfStatus:bookingTypes success:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        
        if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
            
            [[DisplayToast sharedManager] dismiss];
            
            NSArray *bookings = result[RES_KEY_BOOKINGS];
            
            for (NSDictionary *booking in bookings) {
                
                Booking *one = [Booking new];
                
                one.bookingId = [booking[PARAM_ID] longLongValue];
                one.status = [booking[PARAM_BOOKING_STATUS] integerValue];
                one.duration = [booking[PARAM_DURATION] integerValue];
                //one.rate = [booking[PARAM_RATE] floatValue];
                one.rate = [booking[PARAM_MODEL_RATE_PER_HOUR] floatValue];
                one.location = booking[PARAM_LOCATION];
                one.eventLat = [booking[PARAM_EVENT_LATITUDE] doubleValue];
                one.eventLng = [booking[PARAM_EVENT_LONGITUDE] doubleValue];
                one.comment = booking[PARAM_COMMENT];
                one.wear = booking[PARAM_WEAR];
                one.notifyStatus = [booking[PARAM_NOTIFY_STATUS] integerValue];
                
                if (booking[PARAM_ARRIVED_TIME] != kCFNull)
                one.arrivedDateTime = [NSDate dateFromMysqlDateTimeString:booking[PARAM_ARRIVED_TIME]];
                
                if (booking[PARAM_BOOK_DATE] != kCFNull)
                one.bookDate = [NSDate dateFromMysqlDateString:booking[PARAM_BOOK_DATE]];
                
                if (booking[PARAM_APPOINTMENT_DATETIME] != kCFNull)
                one.appointmentDateTime = [NSDate dateFromMysqlDateTimeString:booking[PARAM_APPOINTMENT_DATETIME]];
                
                one.client = [Client new];
                one.client.clientId = [booking[PARAM_CLIENT_ID] longLongValue];
                one.client.name = booking[PARAM_NAME];
                one.client.phone = booking[PARAM_PHONE];
                
                NSDate *bookingDate = NULL;
                // check if arrive date avilable
                if(one.arrivedDateTime != nil){
                    bookingDate = one.arrivedDateTime;
                } else if(one.appointmentDateTime != nil){ // fetch appointmenet date if arrive date NULL
                    bookingDate = one.appointmentDateTime;
                }
                
                if(self.bookingCat == PAST || self.bookingCat == CURRENT) {
                    
                    NSCalendar* calendar = [NSCalendar currentCalendar];
                    NSDate* now = [NSDate date];
                    int differenceInDays = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:bookingDate] - [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:now];
                    
                    // Check bookings which are not complete by client and it is of back date
                    if(self.bookingCat == PAST){
                        if(differenceInDays < 0){
                            [arrBookings addObject:one];
                        }
                    }else{
                        if(differenceInDays >= 0){
                            [arrBookings addObject:one];
                        }
                    }
                }else{
                    [arrBookings addObject:one];
                }
            }
            
            if (self.bookingCat == CURRENT)
            [self.delegate curBookingCountFetched:[arrBookings count]];
            
            [_tblView reloadData];
            
        } else {
            [[DisplayToast sharedManager] dismiss];
            [[DisplayToast sharedManager] showErrorWithStatus:result[RES_KEY_ERROR]];
        }
        
    } failure:^(NSError *error) {
        [[DisplayToast sharedManager] dismiss];
        [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)initUI {
    
    self.showMenuBtn = YES;
    
    [super initUI];
    
    switch (self.bookingCat) {
            case PREVIOUS:
            //_lblTitle.text = @"PREVIOUS BOOKINGS";
            _lblTitle.text = @"COMPLETED BOOKINGS";
            break;
            
            case CANCEL:
            _lblTitle.text = @"CANCELLED BOOKINGS";
            break;
            
            case PAST:
            _lblTitle.text = @"PAST BOOKINGS";
            break;
            
            case PENDING:
            _lblTitle.text = @"PENDING BOOKINGS";
            break;
            
        default:
            break;
    }
    
    [self.view removeGestureRecognizer:self.recognizer];
}

#pragma mark - Action Delegate

- (IBAction)actionBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Data Source / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return arrBookings.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 57;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BookingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Booking *booking = arrBookings[indexPath.row];
    
    cell.lblClientName.text = booking.client.name;
    cell.lblLocation.text = booking.location;
    cell.lblAppointmentTime.text = [dateFormatter stringFromDate:booking.appointmentDateTime];
    cell.lblCalDay.text = [[cell.lblAppointmentTime.text  componentsSeparatedByString:@","][0] uppercaseString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BookingDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingDetailVC"];
    vc.booking = arrBookings[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
