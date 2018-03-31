//
//  Booking.h
//  Models2You
//
//  Created by user on 10/1/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Client.h"

typedef enum {
    CURRENT,
    PENDING,
    PAST,
    CANCEL,
    PREVIOUS
} BOOKING_CATEGORY;

typedef enum {
    
    CREATED,
    BOOKED,
    ACCEPTED,
    DENIED,
    COMPLETED,
    CANCELED
    
} BOOKING_STATUS;

typedef enum {
    NOT_LEFT,
    ON_MY_WAY,
    POSTPONED,
    ARRIVED,
} NOTIFY_STATUS;

@interface Booking : NSObject

@property (nonatomic) long long bookingId;
@property (nonatomic, strong) Client *client;
@property (nonatomic) BOOKING_STATUS status;
@property (nonatomic, strong) NSDate *bookDate;
@property (nonatomic, strong) NSDate *appointmentDateTime;
@property (nonatomic) int duration;
@property (nonatomic) float rate;
@property (nonatomic, strong) NSString *wear;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *location;
@property (nonatomic) double eventLat;
@property (nonatomic) double eventLng;
@property (nonatomic, strong) NSDate *arrivedDateTime;
@property (nonatomic) NOTIFY_STATUS notifyStatus;

@end
