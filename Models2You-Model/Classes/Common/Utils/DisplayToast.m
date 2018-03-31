//
//  DisplayToast.m
//  Models2You
//
//  Created by RajeshYadav on 27/02/17.
//  Copyright © 2017 Valtus Real Estate, LLC. All rights reserved.
//

#import "DisplayToast.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation DisplayToast

+ (DisplayToast *)sharedManager {
    __strong static DisplayToast *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [DisplayToast new];
    });
    
    return manager;
}

-(void) showWithStatus:(NSString *)text{ // Display with Progress activity
    [SVProgressHUD showWithStatus:text];
}

-(void) dismiss{
    [SVProgressHUD dismiss];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
}

-(void) showErrorWithStatus:(NSString *)text{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudTapped:) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    [SVProgressHUD showErrorWithStatus:text];
}

- (void)showInfoWithStatus:(NSString*)text {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudTapped:) name:SVProgressHUDDidTouchDownInsideNotification object:nil];
    [SVProgressHUD showInfoWithStatus:text];
}

- (void)hudTapped:(NSNotification *)notification
{
    NSLog(@"They tapped the HUD");
    // Cancel logic goes here
    [self dismiss];
}


@end
