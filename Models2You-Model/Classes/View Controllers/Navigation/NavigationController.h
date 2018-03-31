//
//  NavigationController.h
//  Models2You-Model
//
//  Created by user on 10/3/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Booking.h"

@interface NavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *strViewControllerName;
@property (nonatomic) BOOKING_CATEGORY bookingCat;

@end
