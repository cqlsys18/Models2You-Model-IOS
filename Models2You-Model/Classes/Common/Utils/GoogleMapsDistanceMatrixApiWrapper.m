//
//  GoogleMapsDistanceMatrixApiWrapper.m
//  Models2You
//
//  Created by user on 10/20/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "GoogleMapsDistanceMatrixApiWrapper.h"

#import "NetAPIClient.h"
#import "Config.h"
#import <CoreLocation/CoreLocation.h>

//#define GOOGLE_MAPS_DISTANCE_MATRIX_API     @"https://maps.googleapis.com/maps/api/distancematrix/%@"
//#define GOOGLE_MAPS_DISTANCE_MATRIX_API     @"https://maps.googleapis.com/maps/api/distancematrix/%@?%@"
#define GOOGLE_MAPS_DIRECTION_API     @"https://maps.googleapis.com/maps/api/directions/%@"


#define PARAM_KEY       @"key"
//#define PARAM_ORIGINS   @"origins"
//#define PARAM_DESTINS   @"destinations"
#define PARAM_ORIGINS   @"origin"
#define PARAM_DESTINS   @"destination"
#define PARAM_UNIT      @"units"

#define UNIT_METRIC     @"metric"
#define UNIT_IMPERIAL   @"imperial"

#define PARAM_MODE_KEY @"mode"
#define PARAM_DRIVING @"driving"
#define PARAM_TRANSIT @"transit"


@implementation GoogleMapsDistanceMatrixApiWrapper

+ (void)getDistancesBetweenOrigins:(NSArray *)origins
                      destinations:(NSArray *)destinations
                        unitSystem:(UnitSystem)unitSystem
                          inFormat:(OutputFormat)format
                    success:(void (^)(id responseObject)) success
                    failure:(void (^)(NSError *error)) failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (!origins || origins.count == 0) {
        failure([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Empty origins."}]);
        return;
    } else if (!destinations || destinations.count == 0) {
        failure([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Empty destinations."}]);
        return;
    }
    
    NSString *strOrigins = [GoogleMapsDistanceMatrixApiWrapper formatLocations:origins];
    NSString *strDestins = [GoogleMapsDistanceMatrixApiWrapper formatLocations:destinations];
    
    if (!strOrigins || !strDestins)
        failure([NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Invalid origin or destination params."}]);
    
    [params setObject:@"false" forKey:@"sensor"];
    [params setObject:strOrigins forKey:PARAM_ORIGINS];
    [params setObject:strDestins forKey:PARAM_DESTINS];
    [params setObject:PARAM_DRIVING forKey:PARAM_MODE_KEY];
    
    NSString *unit;
    if (unitSystem == METRIC)
        unit = UNIT_METRIC;
    else
        unit = UNIT_IMPERIAL;
    [params setObject:unit forKey:PARAM_UNIT];
    
    //NSString *webServiceURL = [NSString stringWithFormat:GOOGLE_MAPS_DISTANCE_MATRIX_API, (format == JSON) ? @"json":@"xml"];
    NSString *webServiceURL = [NSString stringWithFormat:GOOGLE_MAPS_DIRECTION_API, (format == JSON) ? @"json":@"xml"];
    
    [[NetAPIClient sharedClient] sendToServiceByGET:webServiceURL
                                             params:params
                                       encodeParams:NO
                                            success:success
                                            failure:failure
                                responseContentType:(format == JSON) ? ResponseContentTypeJSON:ResponseContentTypeXML];
}

+ (NSString *)formatLocation:(CLLocation *)location {
    return [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
}

+ (NSString *)formatLocations:(NSArray *)arr {
    
    NSMutableArray *comps = [NSMutableArray array];
    
    for (NSObject *obj in arr) {
        if ([obj isKindOfClass:[NSString class]])
            [comps addObject:obj];
        else if ([obj isKindOfClass:[CLLocation class]])
            [comps addObject:[GoogleMapsDistanceMatrixApiWrapper formatLocation:(CLLocation *)obj]];
        else
            return nil;
    }
    
    return [comps componentsJoinedByString:@"|"];
}

@end
