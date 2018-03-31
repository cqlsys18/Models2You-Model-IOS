//
//  Utils.m
//  Models2You-Model
//
//  Created by RajeshYadav on 11/01/17.
//  Copyright © 2017 Valtus Real Estate, LLC. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>

@implementation Utils
///**
// * @param first First Location
// * @param second Second Location
// * @param precisionLevel up to decimal values/precision level [0 to 8]
// 0        1                111  km
// 1        0.1              11.1 km
// 2        0.01             1.11 km
// 3        0.001            111  m
// 4        0.0001           11.1 m
// 5        0.00001          1.11 m
// 6        0.000001         11.1 cm
// 7        0.0000001        1.11 cm
// 8        0.00000001       1.11 mm
// * @return true if matched, otherwise false.
// */
+(bool) areLocationsSame:(CLLocation *)first withSecondLocation:(CLLocation *)second withPrecisionLevel:(int)precisionLevel{
    if(first != nil && second != nil){
        if(precisionLevel >= 0 && precisionLevel <=8){
            int deltaLat = (int) (first.coordinate.latitude - second.coordinate.latitude);
            int deltaLon = (int) (first.coordinate.longitude - second.coordinate.longitude);
            if(deltaLat != 0 || deltaLon != 0){
                return false; //no need of precision check
            }
            NSString *formatter = [NSString stringWithFormat:@"%%.%df,%%.%df", precisionLevel, precisionLevel, nil];
            NSString *firstKey = [NSString stringWithFormat:formatter, first.coordinate.latitude, first.coordinate.longitude];
            NSString *secondKey = [NSString stringWithFormat:formatter, second.coordinate.latitude, second.coordinate.longitude];
            return [firstKey isEqualToString:secondKey];
        } else {
            return first.coordinate.latitude == second.coordinate.latitude && first.coordinate.longitude == second.coordinate.longitude;
        }
    }
    return false;
}
    
    +(void) displayAlertWithMessage:(NSString *)message{
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }

@end
