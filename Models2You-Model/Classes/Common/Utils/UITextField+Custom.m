//
//  UITextField+Custom.m
//  Models2You-Model
//
//  Created by user on 9/18/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "UITextField+Custom.h"

@implementation UITextField (Custom)

- (void)setPlaceholderColor:(UIColor *)color {
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:(self.placeholder) ? self.placeholder : @"" attributes:@{NSForegroundColorAttributeName:color}];
}

@end
