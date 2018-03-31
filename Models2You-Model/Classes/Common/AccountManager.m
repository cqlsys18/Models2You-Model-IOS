//
//  AccountManager.m
//  project-luan-ludan
//
//  Created by user on 7/30/15.
//  Copyright (c) 2015 Toptal. All rights reserved.
//

#import "AccountManager.h"

#define LOGIN_KEY           @"LOGIN"
#define TOKEN_KEY           @"TOKEN"
#define USER_ID_KEY         @"ID"

#define PICTURE_KEY         @"PICTURE"
#define EMAIL_KEY           @"EMAIL"
#define NAME_KEY            @"NAME"
#define RATE_KEY            @"RATE"
#define ADDRESS_KEY         @"ADDRESS"
#define CITY_KEY            @"CITY"
#define STATE_KEY           @"STATE"
#define ZIPCODE_KEY         @"ZIPCODE"
#define PHONE_KEY           @"PHONE"
#define DOB_KEY             @"DOB"
#define EYECOLOR_KEY        @"EYECOLOR"
#define HAIRCOLOR_KEY       @"HAIRCOLOR"
#define HEIGHT_FOOT_KEY     @"HEIGHT_FOOT"
#define HEIGHT_INCH_KEY     @"HEIGHT_INCH"
#define FAVORITES_KEY       @"FAVORITES"
#define AVAILABILITY_KEY    @"AVAILABILITY"
#define SESSION_TIME_OUT_KEY    @"SESSION_TIME_OUT"

@implementation AccountManager

@synthesize loggedIn = _loggedIn;
@synthesize userId = _userId;
@synthesize sessToken = _sessToken;

@synthesize picture = _picture;
@synthesize email = _email;
@synthesize name = _name;
@synthesize rate = _rate;
@synthesize address = _address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zipcode = _zipcode;
@synthesize phone = _phone;
@synthesize dob = _dob;
@synthesize eyeColor = _eyeColor;
@synthesize hairColor = _hairColor;
@synthesize heightFoot = _heightFoot;
@synthesize heightInch = _heightInch;
@synthesize favorites = _favorites;
@synthesize availability = _availability;
@synthesize sessionTimeOut = _sessionTimeOut;

+ (AccountManager *)sharedManager {
    __strong static AccountManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [AccountManager new];
    });
    
    return manager;
}

- (instancetype)init {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _loggedIn = [defaults boolForKey:LOGIN_KEY];
    _sessToken = [defaults stringForKey:TOKEN_KEY];
    _userId = [defaults integerForKey:USER_ID_KEY];
    
    _picture = [defaults stringForKey:PICTURE_KEY];
    _email = [defaults stringForKey:EMAIL_KEY];
    _name = [defaults stringForKey:NAME_KEY];
    _rate = [defaults floatForKey:RATE_KEY];
    
    _address = [defaults stringForKey:ADDRESS_KEY];
    _city = [defaults stringForKey:CITY_KEY];
    _state = [defaults stringForKey:STATE_KEY];
    _zipcode = [defaults stringForKey:ZIPCODE_KEY];
    
    _phone = [defaults stringForKey:PHONE_KEY];
    _dob = [defaults objectForKey:DOB_KEY];
    _eyeColor = [defaults stringForKey:EYECOLOR_KEY];
    _hairColor = [defaults stringForKey:HAIRCOLOR_KEY];
    _heightFoot = [defaults integerForKey:HEIGHT_FOOT_KEY];
    _heightInch = [defaults integerForKey:HEIGHT_INCH_KEY];
    _favorites = [defaults stringForKey:FAVORITES_KEY];
    _availability = [defaults boolForKey:AVAILABILITY_KEY];
    
    return self;
}

- (BOOL)loggedIn {
    return _loggedIn;
}

- (void)setLoggedIn:(BOOL)loggedIn {
    _loggedIn = loggedIn;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:loggedIn forKey:LOGIN_KEY];
    [defaults synchronize];
}

- (NSString *)sessToken {
    return _sessToken;
}

- (void)setSessToken:(NSString *)sessToken {
    _sessToken = sessToken;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:sessToken forKey:TOKEN_KEY];
    [defaults synchronize];
}

- (long long)userId {
    return _userId;
}

- (void)setUserId:(long long)userId {
    _userId = userId;
       NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:userId forKey:USER_ID_KEY];
    [defaults synchronize];
}

- (NSString *)picture {
    return _picture;
}

- (void)setPicture:(NSString *)picture {
    _picture = picture;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:picture forKey:PICTURE_KEY];
    [defaults synchronize];
}

- (NSString *)email {
    return _email;
}

- (void)setEmail:(NSString *)email {
    _email = email;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:email forKey:EMAIL_KEY];
    [defaults synchronize];
}

- (NSString *)name {
    return _name;
}

- (void)setName:(NSString *)name {
    _name = name;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:NAME_KEY];
    [defaults synchronize];
}

- (float)rate {
    return _rate;
}

- (void)setRate:(float)rate {
    _rate = rate;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:rate forKey:RATE_KEY];
    [defaults synchronize];
}

- (NSString *)address {
    return _address;
}

- (void)setAddress:(NSString *)address {
    _address = address;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:address forKey:ADDRESS_KEY];
    [defaults synchronize];
}

- (NSString *)city {
    return _city;
}

- (void)setCity:(NSString *)city {
    _city = city;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:city forKey:CITY_KEY];
    [defaults synchronize];
}

- (NSString *)state {
    return _state;
}

- (void)setState:(NSString *)state {
    _state = state;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:state forKey:STATE_KEY];
    [defaults synchronize];
}

- (NSString *)zipcode {
    return _zipcode;
}

- (void)setZipcode:(NSString *)zipcode {
    _zipcode = zipcode;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:zipcode forKey:ZIPCODE_KEY];
    [defaults synchronize];
}

- (NSString *)phone {
    return _phone;
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phone forKey:PHONE_KEY];
    [defaults synchronize];
}

- (NSDate *)dob {
    return _dob;
}

- (void)setDob:(NSDate *)dob {
    _dob = dob;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dob forKey:DOB_KEY];
    [defaults synchronize];
}

- (NSString *)eyeColor {
    return _eyeColor;
}

- (void)setEyeColor:(NSString *)eyeColor {
    _eyeColor = eyeColor;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:eyeColor forKey:EYECOLOR_KEY];
    [defaults synchronize];
}

- (NSString *)hairColor {
    return _hairColor;
}

- (void)setHairColor:(NSString *)hairColor {
    _hairColor = hairColor;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:hairColor forKey:HAIRCOLOR_KEY];
    [defaults synchronize];
}

- (NSString *)favorites {
    return _favorites;
}

- (void)setFavorites:(NSString *)favorites {
    _favorites = favorites;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:favorites forKey:FAVORITES_KEY];
    [defaults synchronize];
}

- (int)heightFoot {
    return _heightFoot;
}

- (void)setHeightFoot:(int)heightFoot {
    _heightFoot = heightFoot;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:heightFoot forKey:HEIGHT_FOOT_KEY];
    [defaults synchronize];
}

- (int)heightInch {
    return _heightInch;
}

- (void)setHeightInch:(int)heightInch {
    _heightInch = heightInch;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:heightInch forKey:HEIGHT_INCH_KEY];
    [defaults synchronize];
}

- (BOOL)availability {
    return _availability;
}

- (void)setAvailability:(BOOL)availability {
    _availability = availability;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:availability forKey:AVAILABILITY_KEY];
    [defaults synchronize];
}

- (void)setSessionTimeOut:(int)sessionTimeOut {
    _sessionTimeOut = sessionTimeOut;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:sessionTimeOut forKey:SESSION_TIME_OUT_KEY];
    [defaults synchronize];
}

- (int)sessionTimeOut {
    return _sessionTimeOut;
}

@end
