//
//  DisplayToast.h
//  Models2You
//
//  Created by RajeshYadav on 27/02/17.
//  Copyright © 2017 Valtus Real Estate, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DisplayToast : NSObject

+ (DisplayToast*)sharedManager;

-(void) showWithStatus:(NSString *)text; // Display with Progress activity

-(void) dismiss;

-(void) showErrorWithStatus:(NSString *)text;

- (void)showInfoWithStatus:(NSString*)text;

@end
