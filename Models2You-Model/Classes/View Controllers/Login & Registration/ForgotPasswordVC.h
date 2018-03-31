//
//  ForgotPasswordVC.h
//  Models2You
//
//  Created by user on 10/20/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

@interface ForgotPasswordVC : BaseVC <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivEmailBack;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionSendNewPassword:(id)sender;

@end
