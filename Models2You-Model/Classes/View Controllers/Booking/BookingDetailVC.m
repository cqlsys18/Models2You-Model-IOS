//
//  BookingDetailVC.m
//  Models2You-Model
//
//  Created by user on 9/17/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BookingDetailVC.h"
#import "AccountManager.h"
#import "WebServiceClient.h"
#import "SVProgressHUD.h"
#import "NSDate+Custom.h"

#import "RouteMapVC.h"

#import "AppDelegate.h"
#import "Utils.h"
#import "DisplayToast.h"

@interface BookingDetailVC () <RouteMapVCDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter, *timeFormatter;

@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic) int remainingSecs;

@end

@implementation BookingDetailVC{
    RouteMapVC *_routeMapVC;
    bool _isActionArrived;
    bool _isPoptoSelf;
}

@synthesize booking, dateFormatter, timeFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Update booking list on notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBookingAppointmentCompleteNotification:) name:BOOKING_APPOINTMENT_COMPLETE_CANCEL object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - update screen info
-(void) refreshScreenData{
    self.booking = nil;
    [self initData];
}

    
#pragma mark - Notification
- (void) receiveBookingAppointmentCompleteNotification:(NSNotification *) notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *bookingId = userInfo[@"id"];
    
    if([bookingId longLongValue] == self.bookingId){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Init

- (void)initData {
    
    //[self doTest];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.locale = [NSLocale currentLocale];
    timeFormatter.timeStyle = NSDateFormatterShortStyle;
    
    if (!booking) {
        [self downloadUpdatedBookingInfo];
    }
    
    _btnArrived.exclusiveTouch = true;
    _btnCancel.exclusiveTouch = true;;
    _btnOnMyWay.exclusiveTouch = true;;
    _btnPostponeOrContinue.exclusiveTouch = true;
    _btnAccept.exclusiveTouch = true;
    _btnDeny.exclusiveTouch = true;
}

-(void) downloadUpdatedBookingInfo{
    [[DisplayToast sharedManager] showWithStatus:@"Loading..."];
    
    [[WebServiceClient sharedClient] getBookingInfo:self.bookingId success:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        
        NSLog(@"Booking Detail: %@", result);
        
        if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
            
            [[DisplayToast sharedManager] dismiss];
            
            NSDictionary *one = result[RES_KEY_BOOKING];
            booking = [Booking new];
            
            booking.bookingId = [one[PARAM_ID] longLongValue];
            booking.status = [one[PARAM_BOOKING_STATUS] integerValue];
            booking.duration = [one[PARAM_DURATION] integerValue];
            //booking.rate = [one[PARAM_RATE] floatValue];
            booking.rate = [one[PARAM_MODEL_RATE_PER_HOUR] floatValue];
            booking.location = one[PARAM_LOCATION];
            booking.comment = one[PARAM_COMMENT];
            booking.wear = one[PARAM_WEAR];
            booking.notifyStatus = [one[PARAM_NOTIFY_STATUS] integerValue];
            
            if (one[PARAM_ARRIVED_TIME] != kCFNull)
                booking.arrivedDateTime = [NSDate dateFromMysqlDateTimeString:one[PARAM_ARRIVED_TIME]];
            
            if (one[PARAM_BOOK_DATE] != kCFNull)
                booking.bookDate = [NSDate dateFromMysqlDateString:one[PARAM_BOOK_DATE]];
            
            if (one[PARAM_APPOINTMENT_DATETIME] != kCFNull)
                booking.appointmentDateTime = [NSDate dateFromMysqlDateTimeString:one[PARAM_APPOINTMENT_DATETIME]];
            
            booking.client = [Client new];
            booking.client.clientId = [one[PARAM_CLIENT_ID] longLongValue];
            booking.client.name = one[PARAM_NAME];
            booking.client.phone = one[PARAM_PHONE];
            
            booking.eventLat = [one[PARAM_EVENT_LATITUDE] doubleValue];
            booking.eventLng = [one[PARAM_EVENT_LONGITUDE] doubleValue];
            
            [self updateUI];
            [self updateStatusUI];
            
            if(_isActionArrived){
                [[DisplayToast sharedManager] showInfoWithStatus:@"Your gig has started shine bright!"];
            }
            
            if(self.notificationMsg != nil){
                [[DisplayToast sharedManager] showInfoWithStatus:_notificationMsg];
                _notificationMsg = nil;
            }
            
        } else {
            //[[DisplayToast sharedManager] dismiss];
          //  [[DisplayToast sharedManager] showErrorWithStatus:result[RES_KEY_ERROR]];
        }
        
    } failure:^(NSError *error) {
        [[DisplayToast sharedManager] dismiss];
        [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)initUI {
    
    self.showMenuBtn = YES;
    
    [super initUI];
    
    [self initData];
    
    [self updateUI];
    
    [self updateStatusUI];
    
    _tblView.tableFooterView = [UIView new];
}

- (void)updateUI {
    
    _lblName.text = booking.client.name;
    _lblBookDate.text = [dateFormatter stringFromDate:booking.bookDate];
    _lblAppointmentDate.text = [dateFormatter stringFromDate:booking.appointmentDateTime];
    _lblAppointmentTime.text = [timeFormatter stringFromDate:booking.appointmentDateTime];
    _lblDuration.text = [NSString stringWithFormat:@"%d HOUR%@", booking.duration, (booking.duration > 1) ? @"S":@""];
    _lblRate.text = [NSString stringWithFormat:@"$%.2f", booking.rate];
    _lblLocation.text = booking.location;
    _lblWear.text = booking.wear;
    _lblComment.text = booking.comment;
    
    _viewTime.hidden = YES;
}

- (void)updateStatusUI {
    
    if (booking.status == ACCEPTED) {

        //[Change-Request]: Accept bookings and then cancel booking when they change their mind
//        NSDate *deadline = [booking.appointmentDateTime dateByAddingTimeInterval:-3600 * 2];
//        
//        if ([[NSDate date] compare:deadline] == NSOrderedDescending)
//            _btnCancel.hidden = YES;
//        else
//            _btnCancel.hidden = NO;
        
        _viewCurrentActions.hidden = NO;
        _viewPendingActions.hidden = YES;
    } else if (booking.status == BOOKED) {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
        
        _viewPendingActions.hidden = NO;
        _viewCurrentActions.hidden = YES;
    } else {
        
        _viewCurrentActions.hidden = YES;
        _viewPendingActions.hidden = YES;
    }
    
    
    _viewStatus.hidden = NO;
    
    if (!booking) {
        _viewStatus.hidden = YES;
    } else {
        switch (booking.status) {
            case DENIED:
                
                _lblStatus.text = @"DENIED";
                break;
            case COMPLETED:
                
                _lblStatus.text = @"COMPLETED";
                break;
            case CANCELED:
                
                _lblStatus.text = @"CANCELLED";
                break;
            default:
                
                _viewStatus.hidden = YES;
                break;
        }
    }
    
    [self updateNotifyStatusUI];
}

- (void)doTest {
    booking = [Booking alloc];
    booking.status = BOOKED;
}

- (void)updateNotifyStatusUI {
    
    _btnOnMyWay.hidden = YES;
    _btnCancel.hidden = NO;
    _btnArrived.hidden = YES;
    _btnPostponeOrContinue.hidden = YES;
    
    if (booking && booking.status == ACCEPTED) {
    
        switch (booking.notifyStatus) {
            case NOT_LEFT:
                
                _btnOnMyWay.hidden = NO;
                
                break;
                
            case ON_MY_WAY:
                
                //_btnArrived.hidden = NO;
                //_btnPostponeOrContinue.hidden = NO;
                _btnOnMyWay.hidden = NO;
                
                // calculate time left for appointment time
                _viewTime.hidden = NO;
                
                [_btnPostponeOrContinue setImage:[UIImage imageNamed:@"PostponeBtn"] forState:UIControlStateNormal];
                
                [_btnOnMyWay setImage:[UIImage imageNamed:@"viewmap"] forState:UIControlStateNormal];
                
                break;
                
            case POSTPONED:
                
                _btnPostponeOrContinue.hidden = NO;
                
                [_btnPostponeOrContinue setImage:[UIImage imageNamed:@"ContinueBtn"] forState:UIControlStateNormal];
                
                break;
                
            case ARRIVED:
                
                _btnCancel.hidden = YES;
                _btnCall.hidden = YES;
                
                
                // calculate time left for meeting end
                _viewTime.hidden = NO;
                
                break;
                
            default:
                break;
        }
    }
    
    [self checkAndUpdateLeftTime];
}

-(void) checkAndUpdateLeftTime{
    
    if(_countDownTimer){
        NSTimer *temp = _countDownTimer;
        _countDownTimer = nil;
        [temp invalidate];
    }
    
    if(booking.notifyStatus == ON_MY_WAY){
        // Check appointment time with current time and show remaining time
        // calculate from current time
        if(booking.appointmentDateTime && booking.appointmentDateTime < [NSDate date]){
            _remainingSecs = [booking.appointmentDateTime timeIntervalSinceNow];
            if(_remainingSecs > 0){
                _remainingSecs = fabs(_remainingSecs);
                _viewTime.hidden = NO;
                _lblTimeLeft.text = [self timeFormatted:_remainingSecs];
                
                _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(oneSecTicked) userInfo:nil repeats:YES];
                [_countDownTimer fire];
            }else{
                _viewTime.hidden = YES;
            }
        }else{
            _viewTime.hidden = YES;
        }
    }else if(booking.notifyStatus == ARRIVED){
        // calculate from current time
        if(booking.arrivedDateTime){
            _remainingSecs = MAX((3600 * booking.duration) + [booking.arrivedDateTime timeIntervalSinceNow], 0);
            if(_remainingSecs > 0){
                _viewTime.hidden = NO;
                _lblTimeLeft.text = [self timeFormatted:_remainingSecs];
                
                _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(oneSecTicked) userInfo:nil repeats:YES];
                [_countDownTimer fire];
            }else{
                _viewTime.hidden = YES;
            }
        }else{
            _viewTime.hidden = YES;
        }
    }else{
        _viewTime.hidden = YES;
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    NSString *timeString =@"";
    NSString *formatString=@"";
    if(hours > 0){
        formatString=hours==1?@"%d hr":@"%d hrs";
        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,hours]];
    }
    if(minutes > 0 || hours > 0 ){
        formatString=minutes==1?@" %d min":@" %d mins";
        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,minutes]];
    }
    if(seconds > 0 || hours > 0 || minutes > 0){
        formatString=seconds==1?@" %d sec":@" %d secs";
        timeString  = [timeString stringByAppendingString:[NSString stringWithFormat:formatString,seconds]];
    }
    return timeString;
    
}


#pragma mark - Timer Delegate

- (void)oneSecTicked {
    
    NSString *remainingTime = nil;
    remainingTime = [self timeFormatted:_remainingSecs];
    
    _lblTimeLeft.text = remainingTime;
    if(_routeMapVC){
        [_routeMapVC updateRemainingTime:remainingTime];
    }
    
    if (_remainingSecs == 0) {
        
        _viewTime.hidden = YES;
        
        NSTimer *temp = _countDownTimer;
        _countDownTimer = nil;
        [temp invalidate];
    }
    
    _remainingSecs--;
}


- (IBAction)availabilityChanged {
    [AccountManager sharedManager].availability = false;
    
    [[WebServiceClient sharedClient] setAvailability:[AccountManager sharedManager].availability checkAvailabilityDateTime:nil success:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        NSLog(@"%@", result[RES_KEY_SUCCESS]);
        NSLog(@"%@", result[RES_KEY_ERROR]);
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - Action Delegate

- (IBAction)actionBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionCancel:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"CANCEL" message:@"Are you sure you want to cancel this booking?" preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"REASON";
    }];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        booking.status = CANCELED;
        [[WebServiceClient sharedClient] setStatusOfBooking:booking.bookingId status:CANCELED additionalParams:@{PARAM_REASON:ac.textFields[0].text} success:nil failure:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModifyCurBookingCount object:nil userInfo:@{MODIFY_COUNT_KEY:@(-1)}];
        
        [self updateStatusUI];
        
        if(_isPoptoSelf){ // pop navigate to self
            [self.navigationController popToViewController:self animated:YES];
        }
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)actionDeny:(id)sender {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"DENY" message:@"Are you sure you want to deny this booking?" preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"REASON";
    }];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        booking.status = DENIED;
        [[WebServiceClient sharedClient] setStatusOfBooking:booking.bookingId status:DENIED additionalParams:@{PARAM_REASON:ac.textFields[0].text} success:nil failure:nil];
        
        [self updateStatusUI];
    }]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)actionAccept:(id)sender {
    
    if(_routeMapVC == nil){
        
        booking.status = ACCEPTED;
        
        //[CHANGE-REQUEST]: Check success and failure of Booking accept
        //[[WebServiceClient sharedClient] setStatusOfBooking:booking.bookingId status:ACCEPTED additionalParams:nil success:nil failure:nil];
        [[WebServiceClient sharedClient] setStatusOfBooking:booking.bookingId status:ACCEPTED additionalParams:nil success:^(id responseObject) {
            
            NSDictionary *result = responseObject;
            
            if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
                [self updateStatusUI];
                
//                UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"Congratulations!\nThank you for confirming!" preferredStyle:UIAlertControllerStyleAlert];
                
//                47 UPDATE
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"You are now booked!\nThank you for confirming.\nRemember to shine bright! Give out great energy and vibes.Enjoy your time so that Models2you books you again. Thank you for being fabulous enjoy your gig!" preferredStyle:UIAlertControllerStyleAlert];

                
                [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    //[CHANGE-REQUEST]: go to the map view after booking is accepted
                    // Check booking is in within 2 hours
                    NSDate *deadline = [booking.appointmentDateTime dateByAddingTimeInterval:-3600 * 2];
                    if ([[NSDate date] compare:deadline] == NSOrderedDescending){
                        [self actionOnMyWay:nil];
                    }
                    
                }]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationModifyCurBookingCount object:nil userInfo:@{MODIFY_COUNT_KEY:@(+1)}];
                
                [self presentViewController:ac animated:YES completion:nil];
            }else{
                [[DisplayToast sharedManager] showErrorWithStatus:result[RES_KEY_ERROR]];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (IBAction)actionOnMyWay:(id)sender {
    if(booking.notifyStatus != ON_MY_WAY){
        booking.notifyStatus = ON_MY_WAY;
        [self updateNotifyStatusUI];
        
        [[WebServiceClient sharedClient] setNotifyStatusOfBooking:booking.bookingId status:booking.notifyStatus additionalParams:nil success:nil failure:nil];
        
        // change availability
        [self availabilityChanged];
    }
    
    // Add map view for drive direction
    ////////////////////////////////////////////////////////////////////////////////////////////
    if(_routeMapVC){
        _routeMapVC.delegate = nil;
        _routeMapVC = nil;
    }
    
    if(_routeMapVC == nil){
        _routeMapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RouteMapVC"];
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if(delegate){
            _routeMapVC.sourceLocation = CLLocationCoordinate2DMake(delegate.curLocation.coordinate.latitude, delegate.curLocation.coordinate.longitude);
        }
        _routeMapVC.destinationLocation = CLLocationCoordinate2DMake(booking.eventLat, booking.eventLng);
        _routeMapVC.delegate = self;
        
        if (booking.notifyStatus == ON_MY_WAY) {
            _routeMapVC.isPostponeBtnTextChange = NO;
        }else{
            _routeMapVC.isPostponeBtnTextChange = YES;
        }
        [self.navigationController pushViewController:_routeMapVC animated:YES];
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
}

- (IBAction)actionArrived:(id)sender {
    booking.notifyStatus = ARRIVED;
    _isActionArrived = true;
    [self updateNotifyStatusUI];
    
    //[[WebServiceClient sharedClient] setNotifyStatusOfBooking:booking.bookingId status:booking.notifyStatus additionalParams:nil success:nil failure:nil];
    
    [[DisplayToast sharedManager] showWithStatus:@"Loading..."];
    // Update book information after model arrived
    ////////////////////////////////////////////////////////////////////////////////////////////
    [[WebServiceClient sharedClient] setNotifyStatusOfBooking:booking.bookingId status:booking.notifyStatus additionalParams:nil success:^(id responseObject) {
        
        [[DisplayToast sharedManager] dismiss];
        
        // download update booking info
        if(booking){
            self.bookingId = booking.bookingId;
            booking = nil;
        }
        if (!booking) {
            [self downloadUpdatedBookingInfo];
        }
    } failure:^(NSError *error) {
        [[DisplayToast sharedManager] dismiss];
        [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
    }];
    ////////////////////////////////////////////////////////////////////////////////////////////
}

- (IBAction)actionPostponeOrContinue:(id)sender {
    
    if (booking.notifyStatus == ON_MY_WAY) {
        booking.notifyStatus = POSTPONED;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        void (^handlerBlock)(UIAlertAction *action) = ^(UIAlertAction * _Nonnull action) {
            
            NSUInteger idx = [alertController.actions indexOfObject:action];
            
            NSUInteger delay;
            
            if (idx == 0)
                delay = 5;
            else if (idx == 1)
                delay = 10;
            else
                delay = 15;
            
            [[DisplayToast sharedManager] showWithStatus:@"Processing..."];
            [[WebServiceClient sharedClient] setNotifyStatusOfBooking:booking.bookingId status:booking.notifyStatus additionalParams:@{PARAM_DELAY:@(delay)} success:^(id responseObject) {
                
                // download update booking info
                if(booking){
                    self.bookingId = booking.bookingId;
                    booking = nil;
                }
                if (!booking) {
                    [self downloadUpdatedBookingInfo];
                }
                
//                [self updateNotifyStatusUI];
            } failure:^(NSError *error) {
                [[DisplayToast sharedManager] dismiss];
                [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
            }];
        };
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"5 mins" style:UIAlertActionStyleDefault handler:handlerBlock]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"10 mins" style:UIAlertActionStyleDefault handler:handlerBlock]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"15 mins" style:UIAlertActionStyleDefault handler:handlerBlock]];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
        
    } else {
        booking.notifyStatus = ON_MY_WAY;
        
        [[DisplayToast sharedManager] showWithStatus:@"Processing..."];
        [[WebServiceClient sharedClient] setNotifyStatusOfBooking:booking.bookingId status:booking.notifyStatus additionalParams:nil success:^(id responseObject) {
            
            // download update booking info
            if(booking){
                self.bookingId = booking.bookingId;
                booking = nil;
            }
            if (!booking) {
                [self downloadUpdatedBookingInfo];
            }
            
            //[self updateNotifyStatusUI];
            
        } failure:^(NSError *error) {
            [[DisplayToast sharedManager] dismiss];
            [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
        }];
    }
    
    
}

- (IBAction)actionCallClient:(id)sender {
    
//    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:booking.client.phone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    NSString *callerId = [AccountManager sharedManager].phone;
    [[WebServiceClient sharedClient] callInitiateWithCallerPhoneNumber:callerId withCalleePhoneNumber:booking.client.phone success:^(id responseObject){
        NSLog(@"%@", responseObject);
        
        //TWILIO_CALLING_MSG
        [[[UIAlertView alloc] initWithTitle:nil message:TWILIO_CALLING_MSG delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - RouteMapVCDelegate method implementation

- (void)arrivedBtnPressed{
    [self actionArrived:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if(_routeMapVC){
        _routeMapVC.delegate = nil;
        _routeMapVC = nil;
    }
}
- (void)postPoneOrContinueBtnPressed{
    [self actionPostponeOrContinue:nil];
}

- (void)cancelBtnPressed{
    _isPoptoSelf = true;
    [self actionCancel:nil];
}

@end
