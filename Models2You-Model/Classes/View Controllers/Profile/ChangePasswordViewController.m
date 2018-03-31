//
//  ChangePasswordViewController.m
//  Models2You-Model
//
//  Created by RajeshYadav on 19/04/17.
//  Copyright © 2017 Valtus Real Estate, LLC. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UITextField+Custom.h"
#import "DisplayToast.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewAlertBg.layer.borderWidth = 2;
    self.viewAlertBg.layer.borderColor = [UIColor colorWithRed:202.0/255.0 green:156.0/255.0 blue:52.0/255.0 alpha:1.0].CGColor;
    self.viewAlertBg.layer.cornerRadius = 5;
    
    [_txtNewPassword setDelegate:self];
    [_txtConfirmPassword setDelegate:self];

    [_txtNewPassword setPlaceholderColor:[UIColor whiteColor]];
    [_txtConfirmPassword setPlaceholderColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtNewPassword) {
        [self.txtNewPassword resignFirstResponder];
        [self.txtConfirmPassword becomeFirstResponder];
    } else if (textField == self.txtConfirmPassword) {
        // here you can define what happens
        // when user presses return on the email field
        [self.view endEditing:YES];
    }
    return YES;
}


-(bool) isValidatePassword{
    NSString *newPassword = nil;
    NSString *confirmPassword = nil;
    NSString *strMessage = nil;
    if(_txtNewPassword != nil && _txtNewPassword.text != nil && _txtNewPassword.text.length > 0 && [_txtNewPassword.text caseInsensitiveCompare:@" "] != NSOrderedSame){
        newPassword = _txtNewPassword.text;
    }else{
        strMessage = @"Please input password.";
    }
    
    if(_txtConfirmPassword != nil && _txtConfirmPassword.text != nil && _txtConfirmPassword.text.length > 0 && [_txtConfirmPassword.text caseInsensitiveCompare:@" "] != NSOrderedSame){
        confirmPassword = _txtNewPassword.text;
    }else{
        strMessage = @"Please input confirm password.";
    }
    
    if(newPassword != nil && confirmPassword != nil && [newPassword compare:confirmPassword] == NSOrderedSame){
        return true;
    }else{
        [[DisplayToast sharedManager] showInfoWithStatus:strMessage];
    }
    
    return false;
}

#pragma mark - Action method implementation
- (IBAction)actionCancel:(id)sender{
    if(_delegate && [(id)_delegate respondsToSelector:@selector(removeChangePasswordViewControllerScr)]){
        [_delegate removeChangePasswordViewControllerScr];
    }
}

- (IBAction)actionOk:(id)sender{
    if([self isValidatePassword]){
        if(_delegate && [(id)_delegate respondsToSelector:@selector(removeChangePasswordViewControllerScrWithPassword:)]){
            [_delegate removeChangePasswordViewControllerScrWithPassword:_txtNewPassword.text];
        }
    }
}

@end
