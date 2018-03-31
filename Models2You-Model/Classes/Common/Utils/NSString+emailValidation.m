//
//  NSString+emailValidation.h
//  Shiwa
//
//  Created by user on 7/28/15.
//  Copyright (c) 2015 Shiwa. All rights reserved.
//

#import "NSString+EmailValidation.h"

@implementation NSString (EmailValidation)

- (BOOL)isValidEmail
{
    static NSRegularExpression * regex = nil;
    if (!regex)
    {
        regex = [[NSRegularExpression alloc] initWithPattern:@"^[a-zA-Z0-9\\._%+\\-]+@[a-zA-Z0-9\\-]+(\\.[a-zA-Z0-9\\-]+)*$" options:0 error:nil];
    }
    return nil != [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
}

@end
