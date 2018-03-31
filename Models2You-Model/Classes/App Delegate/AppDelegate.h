//
//  AppDelegate.h
//  Models2You-Model
//
//  Created by user on 9/14/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import "Booking.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) long long bookingId;

@property (strong, nonatomic) CLLocation *curLocation; // current device location
@property (strong,nonatomic) NSMutableArray * imgarray;
@property (strong,nonatomic) NSMutableArray * pdfArrayData;
@property (strong,nonatomic) NSMutableDictionary * signUpDataDic;
@end

