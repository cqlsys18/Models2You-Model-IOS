//
//  ModelAnnotation.h
//  Models2You
//
//  Created by user on 9/23/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@protocol AnnotationViewDelegate <NSObject>

- (void)coordinateDidChange:(CLLocationCoordinate2D)newCoordinate;

@end

@interface UserAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *customTitle;

@property (nonatomic, strong) UIImage *annotImage;

@property (nonatomic) BOOL isUserLocation;

@property (nonatomic, strong) CLLocation *userLocation;

@property (nonatomic, strong) id<AnnotationViewDelegate> delegate;

- (instancetype)initWithLocation:(CLLocation *)location;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
