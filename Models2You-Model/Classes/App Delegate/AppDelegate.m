//
//  AppDelegate.m
//  Models2You-Model
//
//  Created by user on 9/14/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "AccountManager.h"
#import "WebServiceClient.h"
#import "NSData+Custom.h"
#import "BookingDetailVC.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic) BOOL launchByPush;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _signUpDataDic = [[NSMutableDictionary alloc]init];
    application.applicationIconBadgeNumber = 0;
    
    [self initUI];
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey])
        self.launchByPush = YES;
    
    if (launchOptions[UIApplicationLaunchOptionsLocationKey] && [AccountManager sharedManager].loggedIn) {
        
        NSLog(@"App launch by location update and start monitoring location changes.");
        
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        [self.manager startMonitoringSignificantLocationChanges];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // add new local notification
    [self setLogoutNotification];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (self.manager) {
        
        NSLog(@"App enter foreground and stop monitoring location changes.");
        
        [self.manager stopMonitoringSignificantLocationChanges];
        self.manager = nil;
    }
    
    // update application badge count
    application.applicationIconBadgeNumber = 0;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self deleteLogoutNotification];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // remove pervious local notification
    [self deleteLogoutNotification];
    
    // add new local notification
    [self setLogoutNotification];
}

#pragma mark - Push Notification

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    
    if (notificationSettings.types != types) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSuggestChangeNotiSettings object:nil];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *strToken = [deviceToken description];
    strToken = [[strToken componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""];
    strToken = [[strToken componentsSeparatedByCharactersInSet:[NSCharacterSet nonBaseCharacterSet]] componentsJoinedByString:@""];
    
    [[WebServiceClient sharedClient] updateDeviceTokenToToken:strToken success:nil failure:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Error in registration for remote notification. Error: %@", error);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
    long long bookingId = [userInfo[@"id"] longLongValue];
    
    if ([identifier isEqualToString:ACTION_ACCEPT]) {
        
        [[WebServiceClient sharedClient] setStatusOfBooking:bookingId status:ACCEPTED additionalParams:nil success:nil failure:nil];
    } else {
        
        [[WebServiceClient sharedClient] setStatusOfBooking:bookingId status:DENIED additionalParams:nil success:nil failure:nil];
    }
    
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1;
    
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber - 1;
    
    long long bookingId = [userInfo[@"id"] longLongValue];
    NSString *alertMessage = [userInfo[@"aps"] objectForKey:@"alert"];
    
    if (self.launchByPush) {
        
        self.launchByPush = NO;
        
        self.bookingId = bookingId;
    } else {
        
        if (application.applicationState == UIApplicationStateActive) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Notification" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
            
            NSInteger status = -1;
            if(userInfo[@"status"] != nil){
                status = [userInfo[@"status"] integerValue];
            }
            
            if(status == BOOKED){
                [ac addAction:[UIAlertAction actionWithTitle:@"Deny" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    ///////////////////////////////////////////////////////////////////////////
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"DENY" message:@"Are you sure you want to deny this booking?" preferredStyle:UIAlertControllerStyleAlert];
                    
                    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        
                        textField.placeholder = @"REASON";
                    }];
                    
                    [ac addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                    }]];
                    [ac addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        [[WebServiceClient sharedClient] setStatusOfBooking:bookingId status:DENIED additionalParams:@{PARAM_REASON:ac.textFields[0].text} success:nil failure:nil];
                        
                    }]];
                    
                    // [self presentViewController:ac animated:YES completion:nil];
                    [self.window.rootViewController presentViewController:ac animated:YES completion:nil];
                    ///////////////////////////////////////////////////////////////////////////
                    
                }]];
                [ac addAction:[UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self showNotificationDetails:bookingId withNotificationMsg:nil];
                }]];
                
                [self.window.rootViewController presentViewController:ac animated:YES completion:nil];
            }else{
                
   
                if([self checkBookingDetailScreen:bookingId]){
                    [self updateBookingDetailScreen:bookingId withNotificationMsg:alertMessage];
                } else {
//                    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                        
//                    }]];
                    
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Notification" message:userInfo[@"aps"][@"alert"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    [ac addAction:[UIAlertAction actionWithTitle:@"Deny" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                    }]];
                    [ac addAction:[UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [self showNotificationDetails:bookingId withNotificationMsg:nil];
                    }]];
                    
                    [self.window.rootViewController presentViewController:ac animated:YES completion:nil];

                }
                
                if(status == COMPLETED || status == CANCELED || status == DENIED){
                    // update current booking list
                    // send booking id in notification
                    [[NSNotificationCenter defaultCenter] postNotificationName:BOOKING_APPOINTMENT_COMPLETE_CANCEL object:nil userInfo:userInfo];
                }
            }
            //[self.window.rootViewController presentViewController:ac animated:YES completion:nil];
        } else {
            
            [self showNotificationDetails:bookingId withNotificationMsg:alertMessage];
        }
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)showNotificationDetails:(long long)bookingId withNotificationMsg:(NSString *)notificationMsg{
    BookingDetailVC *vc = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"BookingDetailVC"];
    vc.bookingId = bookingId;
    vc.notificationMsg = notificationMsg;
    [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:YES];
}

- (bool) updateBookingDetailScreen:(long long)bookingId withNotificationMsg:(NSString *)notificationMsg{
    bool isScreenFound = false;
    UINavigationController *navigationContollerObj = (UINavigationController *)self.window.rootViewController;
    
    if(navigationContollerObj != nil){
        for (UIViewController* viewController in navigationContollerObj.viewControllers) {
            
            //This if condition checks whether the viewController's class is MyGroupViewController
            // if true that means its the MyGroupViewController (which has been pushed at some point)
            if ([viewController isKindOfClass:[BookingDetailVC class]] ) {
                
                // Here viewController is a reference of UIViewController base class of MyGroupViewController
                // but viewController holds MyGroupViewController  object so we can type cast it here
                BookingDetailVC *bookingDetailVC = (BookingDetailVC*)viewController;
                bookingDetailVC.bookingId = bookingId;
                bookingDetailVC.notificationMsg = notificationMsg;
                [bookingDetailVC refreshScreenData];
                break;
            }
        }
    }
    
    return isScreenFound;
}

- (bool) checkBookingDetailScreen:(long long)bookingId{
    bool isScreenFound = false;
    UINavigationController *navigationContollerObj = (UINavigationController *)self.window.rootViewController;
    
    if(navigationContollerObj != nil){
        for (UIViewController* viewController in navigationContollerObj.viewControllers) {
            
            //This if condition checks whether the viewController's class is MyGroupViewController
            // if true that means its the MyGroupViewController (which has been pushed at some point)
            if ([viewController isKindOfClass:[BookingDetailVC class]] ) {
                
                // Here viewController is a reference of UIViewController base class of MyGroupViewController
                // but viewController holds MyGroupViewController  object so we can type cast it here
                BookingDetailVC *bookingDetailVC = (BookingDetailVC*)viewController;
                if(bookingDetailVC.booking.bookingId == bookingId){
                    isScreenFound = true;
                }
                break;
            }
        }
    }
    
    return isScreenFound;
}

#pragma mark - Init UI

- (void)initUI {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"Location changes occured in background and send to server.");
    
    CLLocation *location = [locations lastObject];
    self.curLocation = location; // update current location
    [[WebServiceClient sharedClient] updateLocationWithLat:location.coordinate.latitude
                                                       lon:location.coordinate.longitude
                                                   success:nil
                                                   failure:nil];
    
    // TODO: Change pin on location update implement notification for location update
    [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOCATION_UPDATE object:nil];
}

#pragma mark - Local notification for logout functionality
- (void) application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(nonnull UILocalNotification *)notification completionHandler:(nonnull void (^)())completionHandler{
    if([notification.category  isEqualToString:CATEGORY_LOCAL_NOTIFICATION]){
        
        if([identifier  isEqualToString: ACTION_YES]){
            [self renewAppToken];
            
        }else if([identifier  isEqualToString: ACTION_NO]){
            [self applicationLogout];
        }
    }
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if ([notification.userInfo[PARAM_IDENTIFICATION_KEY] isEqualToString:PARAM_IDENTIFICATION_VALUE]) {
        
        // Check previous notification timeout
        //[self checkAndUpdateLogoutStatusOnTimeOutExpire:notification.fireDate];
        [self renewAppToken];
    }
}

-(void) setLogoutNotification{
    
    if([AccountManager sharedManager].loggedIn){
        // self registerNotificationTypes
        [self registerNotificationTypes];
        
        AccountManager *manager = [AccountManager sharedManager];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:manager.sessionTimeOut];
        localNotification.alertBody = @"Are you still available";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:PARAM_IDENTIFICATION_VALUE, PARAM_IDENTIFICATION_KEY, nil];
        localNotification.category = CATEGORY_LOCAL_NOTIFICATION;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self saveLocalNotification:localNotification];
    }
}


- (void)registerNotificationTypes {
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:[self composeCategories]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

- (NSSet *)composeCategories {
    UIMutableUserNotificationAction *acceptAction =
    [[UIMutableUserNotificationAction alloc] init];
    
    // Define an ID string to be passed back to your app when you handle the action
    acceptAction.identifier = ACTION_YES;
    
    // Localized string displayed in the action button
    acceptAction.title = @"YES";
    
    // If you need to show UI, choose foreground
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    
    // Destructive actions display in red
    acceptAction.destructive = NO;
    
    // Set whether the action requires the user to authenticate
    acceptAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *denyAction = [[UIMutableUserNotificationAction alloc] init];
    denyAction.identifier = ACTION_NO;
    denyAction.title = @"NO";
    denyAction.activationMode = UIUserNotificationActivationModeBackground;
    denyAction.destructive = YES;
    denyAction.authenticationRequired = YES;
    
    // First create the category
    UIMutableUserNotificationCategory *bookCategory =
    [[UIMutableUserNotificationCategory alloc] init];
    
    // Identifier to include in your push payload and local notification
    bookCategory.identifier = CATEGORY_LOCAL_NOTIFICATION;
    
    // Add the actions to the category and set the action context
    [bookCategory setActions:@[acceptAction, denyAction]
                  forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to present in a minimal context
    [bookCategory setActions:@[acceptAction, denyAction]
                  forContext:UIUserNotificationActionContextMinimal];
    
    return [NSSet setWithObjects:bookCategory, nil];
}


-(void) deleteLogoutNotification{
    
    // remove set local notification
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    if(eventArray && eventArray.count > 0){
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* event = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = event.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:PARAM_IDENTIFICATION_KEY]];
            if ([uid isEqualToString:PARAM_IDENTIFICATION_VALUE])
            {
                // Check previous notification timeout
                [self checkAndUpdateLogoutStatusOnTimeOutExpire:event.fireDate];
                
                //Cancelling local notification
                [app cancelLocalNotification:event];
                
                // remove notification from NSUserDefault
                [self removeLocalNotification];
                break;
            }
        }
    }else{
        UILocalNotification* localNotification = nil;
        
        localNotification = [self getLocalNotification];
        
        if(localNotification){
            // Check previous notification timeout
            [self checkAndUpdateLogoutStatusOnTimeOutExpire:localNotification.fireDate];
            
            // remove notification from NSUserDefault
            [self removeLocalNotification];
        }
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void) checkAndUpdateLogoutStatusOnTimeOutExpire:(NSDate *)timeOutFireTime{
    NSDate *now = [NSDate date];
    
    NSTimeInterval since1970Now = [now timeIntervalSince1970]; // January 1st 1970
    NSTimeInterval since1970Fire = [timeOutFireTime timeIntervalSince1970]; // January 1st 1970
    
    double resultNow = since1970Now * 1000;
    double resultNFire = since1970Fire * 1000;
    
    if(resultNow > resultNFire){
        // Logout application
        [self applicationLogout];
    }else{
        [self renewAppToken];
    }
}

#pragma mark - Manage notificaiton in NSKeyedArchiver for application background kill
-(void) saveLocalNotification:(UILocalNotification *) notification{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:notification];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:PARAM_IDENTIFICATION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(UILocalNotification *) getLocalNotification{
    UILocalNotification *localNotification = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:PARAM_IDENTIFICATION_KEY];
    if(data){
        localNotification = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return localNotification;
}

-(void) removeLocalNotification{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PARAM_IDENTIFICATION_KEY];
}

#pragma mark - application logout
-(void) applicationLogout{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStopMonitoringSigLocationChanges object:nil];
    [[WebServiceClient sharedClient] updateDeviceTokenToToken:@"" success:nil failure:nil];
    [AccountManager sharedManager].loggedIn = NO;
    [AccountManager sharedManager].availability = NO;
    
    // get navigation controller from
    if([self.window.rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        if(navController){
            [navController popToRootViewControllerAnimated:NO];
        }
    }
}

#pragma mark - application token renew
-(void) renewAppToken{
    [[WebServiceClient sharedClient] renewTokenExpiryWithSuccess:nil failure:nil];
    
    // remove notification from NSUserDefault
    [self removeLocalNotification];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //[self setLogoutNotification];
}

@end
