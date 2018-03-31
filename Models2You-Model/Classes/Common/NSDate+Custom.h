//
//  NSDate+Custom.h
//  Warp
//
//  Created by user on 9/3/15.
//  Copyright (c) 2015 Warp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Custom)

+ (NSDate *)dateFromMysqlDateTimeString:(NSString *)dateTimeString;
+ (NSDate *)dateFromMysqlDateString:(NSString *)dateString;
+ (NSString *)mysqlDateStringFromDate:(NSDate *)date;
+ (NSString *)mysqlDateTimeStringFromDate:(NSDate *)date;

@end
