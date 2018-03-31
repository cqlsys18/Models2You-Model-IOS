//
//  GoogleMapsDistanceMatrixApiWrapper.h
//  Models2You
//
//  Created by user on 10/20/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GOOGLE_PARAM_STATUS     @"status"
#define GOOGLE_STATUS_OK        @"OK"

#define GOOGLE_PARAM_ROWS       @"rows"
#define GOOGLE_PARAM_ELEMENTS   @"elements"
#define GOOGLE_PARAM_DISTANCE   @"distance"
#define GOOGLE_PARAM_DURATION   @"duration"
#define GOOGLE_PARAM_TEXT       @"text"
#define GOOGLE_PARAM_VALUE      @"value"

typedef enum {
    JSON,
    XML
} OutputFormat;

typedef enum {
    
    METRIC,
    IMPERIAL
    
} UnitSystem;

@interface GoogleMapsDistanceMatrixApiWrapper : NSObject

+ (void)getDistancesBetweenOrigins:(NSArray *)origins
                      destinations:(NSArray *)destinations
                        unitSystem:(UnitSystem)unitSystem
                          inFormat:(OutputFormat)format
                           success:(void (^)(id responseObject)) success
                           failure:(void (^)(NSError *error)) failure;

@end
