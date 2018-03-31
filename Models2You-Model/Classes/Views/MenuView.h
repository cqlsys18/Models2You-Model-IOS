//
//  MenuView.h
//  Models2You
//
//  Created by user on 10/2/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate <NSObject>

- (void)actionHideMenu;
- (void)actionUpdateProfile;
- (void)actionManagePhoto;
- (void)actionPendingReservation;
- (void)actionCurrentReservation;
- (void)actionPastReservation;
- (void)actionCancelReservation;
- (void)actionCompleteReservation;
- (void)actionLogout;

@end

@interface MenuView : UIView

@property (nonatomic, strong) id<MenuViewDelegate> delegate;

- (IBAction)actionHideMenu:(id)sender;
- (IBAction)actionUpdateProfile:(id)sender;
- (IBAction)actionManagePhoto:(id)sender;
- (IBAction)actionPendingReservation:(id)sender;
- (IBAction)actionCurrentReservation:(id)sender;
- (IBAction)actionPastReservation:(id)sender;
- (IBAction)actionCancelReservation:(id)sender;
- (IBAction)actionCompleteReservation:(id)sender;
- (IBAction)actionLogout:(id)sender;

@end
