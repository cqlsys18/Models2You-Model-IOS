//
//  Utils.h
//  Models2You-Model
//
//  Created by RajeshYadav on 11/01/17.
//  Copyright © 2017 Valtus Real Estate, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Utils : NSObject
    
+(bool) areLocationsSame:(CLLocation *)first withSecondLocation:(CLLocation *)second withPrecisionLevel:(int)precisionLevel;
    +(void) displayAlertWithMessage:(NSString *)message;
    
    
    @end
