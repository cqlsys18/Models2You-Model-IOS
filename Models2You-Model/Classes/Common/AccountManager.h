//
//  AccountManager.h
//  project-luan-ludan
//
//  Created by user on 7/30/15.
//  Copyright (c) 2015 Toptal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

@property (nonatomic, readwrite) long long userId;
@property (nonatomic, readwrite) NSString *sessToken;

@property (nonatomic, readwrite) BOOL loggedIn;

@property (nonatomic, readwrite) NSString *picture;
@property (nonatomic, readwrite) NSString *email;
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) float rate;
@property (nonatomic, readwrite) NSString *address;
@property (nonatomic, readwrite) NSString *city;
@property (nonatomic, readwrite) NSString *state;
@property (nonatomic, readwrite) NSString *zipcode;
@property (nonatomic, readwrite) NSString *phone;
@property (nonatomic, readwrite) NSDate *dob;
@property (nonatomic, readwrite) NSString *eyeColor;
@property (nonatomic, readwrite) NSString *hairColor;
@property (nonatomic, readwrite) int heightFoot;
@property (nonatomic, readwrite) int heightInch;
@property (nonatomic, readwrite) NSString *favorites;
@property (nonatomic, readwrite) BOOL availability;
@property (nonatomic, readwrite) int sessionTimeOut;

+ (AccountManager*)sharedManager;

@end
