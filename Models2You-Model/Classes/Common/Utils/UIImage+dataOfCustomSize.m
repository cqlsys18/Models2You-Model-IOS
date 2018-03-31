//
//  UIImage+dataOfCustomSize.m
//  Models2You-Model
//
//  Created by user on 9/19/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "UIImage+dataOfCustomSize.h"

@implementation UIImage (dataOfCustomSize)

- (NSData *)dataOfCustomImageSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(newImage);
}

@end
