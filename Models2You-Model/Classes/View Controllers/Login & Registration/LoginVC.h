//
//  LoginVC.h
//  Models2You
//
//  Created by user on 9/13/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

@interface LoginVC : BaseVC <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivUsernameBack;
@property (weak, nonatomic) IBOutlet UIImageView *ivPasswordBack;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)actionLogin:(id)sender;

@end
