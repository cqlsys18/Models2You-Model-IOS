//
//  ModelAnnotation.m
//  Models2You
//
//  Created by user on 9/23/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation


- (instancetype)initWithLocation:(CLLocation *)location {
    
    self.userLocation = location;
    
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    
    //if (self.isUserLocation)
        return self.userLocation.coordinate;
    
    
    //return CLLocationCoordinate2DMake(0, 0);
}

- (NSString *)title {
    return self.customTitle;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    self.userLocation = [self.userLocation initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    
    [self.delegate coordinateDidChange:newCoordinate];
}

@end
