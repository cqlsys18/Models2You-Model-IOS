//
//  HomeVC.m
//  Models2You-Model
//
//  Created by user on 9/16/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "HomeVC.h"

#import "BookingListVC.h"
#import "AccountManager.h"
#import "WebServiceClient.h"
#import "SVProgressHUD.h"
#import <Bolts/Bolts.h>
#import "AppDelegate.h"
#import "Utils.h"

#import "DisplayToast.h"
#import "NSDate+Custom.h"

@interface HomeVC ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) int curBookingCount;

@end

@implementation HomeVC

@synthesize locationManager, curBookingCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self doInit];
    
    [self startUpdateLocation];
}

-(void) viewWillAppear:(BOOL)animated{
    [self availabilityChanged];
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

#pragma mark - Init

- (void)doInit {
    
    [self setupPush];
    
    [self registerForBroadcastNotification];
    
    [self initData];
}

- (void)initData {
    
    [self loadData];
}

- (void)loadData {
    
    [[DisplayToast sharedManager] showWithStatus:@"Loading..."];
    
    BFTaskCompletionSource *tcs1, *tcs2;
    tcs1 = [BFTaskCompletionSource taskCompletionSource];
    tcs2 = [BFTaskCompletionSource taskCompletionSource];
    
    [[BFTask taskForCompletionOfAllTasks:@[tcs1.task, tcs2.task]] continueWithBlock:^id(BFTask *task) {
        
        [[DisplayToast sharedManager] dismiss];
        if (task.error) {
            [[DisplayToast sharedManager] showErrorWithStatus:task.error.localizedDescription];
            return  nil;
        }
        return nil;
    }];
    
    [[WebServiceClient sharedClient] countBookingsOfStatus:@[@(ACCEPTED)] withCurrentDateTimer:[NSDate mysqlDateTimeStringFromDate:[NSDate date]] success:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        
        if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
            
            [tcs1 setResult:nil];
            
            [self curBookingCountFetched:[result[PARAM_COUNT] intValue]];
            
        } else {
            
            [tcs1 setError:[NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:result[RES_KEY_ERROR]}]];
        }
        
    } failure:^(NSError *error) {
        
        [tcs1 setError:error];
    }];
    
    [[WebServiceClient sharedClient] getTotalEarningsWithSuccess:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        
        if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
            
            [tcs2 setResult:nil];
            
            _lblTotalEarnings.text = [NSString stringWithFormat:@"$%.2f", [result[PARAM_TOTAL_EARNING] floatValue]];
            
        } else {
            
            [tcs2 setError:[NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:result[RES_KEY_ERROR]}]];
        }
    } failure:^(NSError *error) {
        
        [tcs2 setError:error];
    }];
}

- (void)initUI {
    
    self.showMenuBtn = YES;
    
    [super initUI];
    
    UIImage *image = [[UIImage imageNamed:@"TextFieldBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    _ivAvailabilityBack.image = image;
    _ivViewBookingBack.image = image;
    _ivExitBack.image = image;
    
    [self availabilityChanged];
}

- (void)registerForBroadcastNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(suggestNotiSettingsChange) name:kNotificationSuggestChangeNotiSettings object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopUpdateLocation) name:kNotificationStopMonitoringSigLocationChanges object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyCurBookingCountBy:) name:kNotificationModifyCurBookingCount object:nil];
}

#pragma mark - Action Delegate

- (IBAction)actionSetStatus:(id)sender {
    [AccountManager sharedManager].availability = ![AccountManager sharedManager].availability;
    
    [self availabilityChanged];
    
    [[WebServiceClient sharedClient] setAvailability:[AccountManager sharedManager].availability checkAvailabilityDateTime:[NSDate mysqlDateTimeStringFromDate:[NSDate date]] success:^(id responseObject) {
        
        NSDictionary *result = responseObject;
        NSLog(@"%@", result[RES_KEY_SUCCESS]);
        NSLog(@"%@", result[RES_KEY_ERROR]);
        
        if([result[RES_KEY_SUCCESS] intValue] == 0){
            // [Change-Request]: on error setAvailability false
            [[DisplayToast sharedManager] showErrorWithStatus:result[RES_KEY_ERROR]];
            BOOL availability = false;
            [[AccountManager sharedManager] setAvailability:availability];
            [_availabilitySwitch setOn:availability];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)availabilityChanged {
    BOOL availability = [AccountManager sharedManager].availability;
    
    [_availabilitySwitch setOn:availability];
    
    if (availability) {
        _lblStatus.text = @"Currently Accepting Booking";
    } else {
        _lblStatus.text = @"Not Accepting Booking";
    }
}

- (IBAction)actionViewBooking:(id)sender {
    
    BookingListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingListVC"];
    vc.bookingCat = CURRENT;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionExit:(id)sender {
    [self stopUpdateLocation];
    
    [[WebServiceClient sharedClient] updateDeviceTokenToToken:@"" success:nil failure:nil];
    
    [[AccountManager sharedManager] setLoggedIn:NO];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Booking List View Delegate

- (void)curBookingCountFetched:(int)count {
    curBookingCount = count;
    _lblNumBooking.text = [NSString stringWithFormat:@"%d Current Booking%@", count, (count > 1) ? @"s":@""];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        
        NSLog(@"User authorized always usage.");
        
        [manager startMonitoringSignificantLocationChanges];
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        
        NSLog(@"Request always usage");
        
        [locationManager requestAlwaysAuthorization];
    } else {
        
        NSLog(@"User denied always usage.");
        
        [self alertAndStartUpdateLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location changes while in foreground");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if([AccountManager sharedManager].loggedIn && (delegate.curLocation == nil || ![Utils areLocationsSame:delegate.curLocation withSecondLocation:location withPrecisionLevel:4])){ //11m level precision // check previous location and new location
        NSLog(@"Location changes while in foreground");
        
        if(delegate){
            delegate.curLocation = location;
        }
        
        [[WebServiceClient sharedClient] updateLocationWithLat:location.coordinate.latitude
                                                           lon:location.coordinate.longitude
                                                       success:^(id responseObject) {
                                                           
                                                           NSDictionary *result = responseObject;
                                                           NSLog(@"location update with response: %@", result);
                                                       }
                                                       failure:nil];
        
        //Change pin on location update implement notification for location update
        [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOCATION_UPDATE object:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
}
#pragma mark - Start/Stop Location Manager

- (void)startUpdateLocation {
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [locationManager requestLocation];
        [locationManager requestWhenInUseAuthorization];
        
        [locationManager startUpdatingLocation];
        
    } else {
        
        NSLog(@"Location services disabled, so alert user");
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Location Services" message:@"For the app to properly work, you need to enable location services in the privacy settings." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)alertAndStartUpdateLocation {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Location Services" message:@"For the app to properly work, you need to enable location services in the app settings." preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    [self presentViewController:ac animated:YES completion:nil];
    
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopUpdateLocation {
    
    NSLog(@"Stop monitoring location changes");
    
    [locationManager stopMonitoringSignificantLocationChanges];
}

#pragma mark - Push

- (void)setupPush {
    [self registerNotificationTypes];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)registerNotificationTypes {
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *currentSettings = [app currentUserNotificationSettings];
    
    if (currentSettings.types != types) {
        
        UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:[self composeCategories]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
}

- (NSSet *)composeCategories {
    UIMutableUserNotificationAction *acceptAction =
    [[UIMutableUserNotificationAction alloc] init];
    
    // Define an ID string to be passed back to your app when you handle the action
    acceptAction.identifier = ACTION_ACCEPT;
    
    // Localized string displayed in the action button
    acceptAction.title = @"Accept";
    
    // If you need to show UI, choose foreground
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    
    // Destructive actions display in red
    acceptAction.destructive = NO;
    
    // Set whether the action requires the user to authenticate
    acceptAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *denyAction = [[UIMutableUserNotificationAction alloc] init];
    denyAction.identifier = ACTION_DENY;
    denyAction.title = @"Deny";
    denyAction.activationMode = UIUserNotificationActivationModeBackground;
    denyAction.destructive = YES;
    denyAction.authenticationRequired = YES;
    
    // First create the category
    UIMutableUserNotificationCategory *bookCategory =
    [[UIMutableUserNotificationCategory alloc] init];
    
    // Identifier to include in your push payload and local notification
    bookCategory.identifier = CATEGORY_BOOK_MODEL;
    
    // Add the actions to the category and set the action context
    [bookCategory setActions:@[acceptAction, denyAction]
                    forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to present in a minimal context
    [bookCategory setActions:@[acceptAction, denyAction]
                    forContext:UIUserNotificationActionContextMinimal];
    
    return [NSSet setWithObjects:bookCategory, nil];
}

- (void)suggestNotiSettingsChange {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Push Notifications" message:@"For the app to work properly, you need to enable all the notification types in Settings. Open Settings to enable them now." preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"Open Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - Broadcast Notification Delegate

- (void)modifyCurBookingCountBy:(NSNotification *)notification {
    [self curBookingCountFetched:curBookingCount + [notification.userInfo[MODIFY_COUNT_KEY] integerValue]];
}

@end
