//
//  NSData+Custom.m
//  Warp
//
//  Created by user on 9/15/15.
//  Copyright (c) 2015 Warp. All rights reserved.
//

#import "NSData+Custom.h"

@implementation NSData (Custom)

- (NSString *)hexString {
    
    const unsigned char *bytes = [self bytes];
    
    if (!bytes) {
        return [NSString string];
    }
    
    NSUInteger length = [self length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:length * 2];
    
    for (int i = 0; i < length; i++) {
        [hexString appendFormat:@"%02x", bytes[i]];
    }
    
    return hexString;
}

@end
