//
//  NSDate+Custom.m
//  Warp
//
//  Created by user on 9/3/15.
//  Copyright (c) 2015 Warp. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

+ (NSDateFormatter *)mysqlDateTimeFormatter {
    
    __strong static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    
    return dateFormatter;
}

+ (NSDateFormatter *)mysqlDateFormatter {
    
    __strong static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    
    return dateFormatter;
}

+ (NSDate *)dateFromMysqlDateTimeString:(NSString *)dateTimeString {
    return [[NSDate mysqlDateTimeFormatter] dateFromString:dateTimeString];
}

+ (NSDate *)dateFromMysqlDateString:(NSString *)dateString {
    return [[NSDate mysqlDateFormatter] dateFromString:dateString];
}

+ (NSString *)mysqlDateStringFromDate:(NSDate *)date {
    return [[NSDate mysqlDateFormatter] stringFromDate:date];
}

+ (NSString *)mysqlDateTimeStringFromDate:(NSDate *)date {
    
    return [[NSDate mysqlDateTimeFormatter] stringFromDate:date];
}

@end
