//
//  MenuView.m
//  Models2You
//
//  Created by user on 10/2/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)actionHideMenu:(id)sender {
    [self.delegate actionHideMenu];
}

- (IBAction)actionUpdateProfile:(id)sender {
    [self.delegate actionUpdateProfile];
}

- (IBAction)actionManagePhoto:(id)sender {
    [self.delegate actionManagePhoto];
}

- (void)actionPendingReservation:(id)sender {
    [self.delegate actionPendingReservation];
}

- (IBAction)actionCurrentReservation:(id)sender {
    [self.delegate actionCurrentReservation];
}

- (IBAction)actionPastReservation:(id)sender {
    [self.delegate actionPastReservation];
}

- (IBAction)actionCancelReservation:(id)sender{
    [self.delegate actionCancelReservation];
}

- (IBAction)actionCompleteReservation:(id)sender {
    [self.delegate actionCompleteReservation];
}

- (IBAction)actionLogout:(id)sender {
    [self.delegate actionLogout];
}

@end
