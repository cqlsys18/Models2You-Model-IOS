//
//  RouteSteps.h
//  Models2You-Model
//
//  Created by RajeshYadav on 19/08/16.
//  Copyright © 2016 Valtus Real Estate, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteSteps : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSNumber *startLocationLat;
@property (nonatomic, strong) NSNumber *startLocationLon;
@property (nonatomic, strong) NSNumber *endLocationLat;
@property (nonatomic, strong) NSNumber *endLocationLon;
@property (nonatomic, strong) NSString *travelMode;
@property (nonatomic, strong) NSString *polyline;
@property (nonatomic, strong) NSString *maneuver;

@end
