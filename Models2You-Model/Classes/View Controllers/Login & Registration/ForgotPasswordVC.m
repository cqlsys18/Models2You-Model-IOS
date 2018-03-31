//
//  ForgotPasswordVC.m
//  Models2You
//
//  Created by user on 10/20/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "ForgotPasswordVC.h"

#import "NSString+emailValidation.h"
#import "SVProgressHUD.h"
#import "WebServiceClient.h"
#import "Utils.h"

#import "DisplayToast.h"

@interface ForgotPasswordVC ()

@property (nonatomic, strong) NSString *strMessage;

@end

@implementation ForgotPasswordVC

@synthesize strMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


#pragma mark - Init

- (void)initUI {
    [super initUI];
    
    _ivEmailBack.image = [[UIImage imageNamed:@"TextFieldBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - Action Delegate

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionSendNewPassword:(id)sender {
    
    if ([self loginFromValid]) {
        
        [[DisplayToast sharedManager] showWithStatus:@"Processing..."];
        
        [[WebServiceClient sharedClient] sendNewPasswordToEmail:_txtEmail.text success:^(id responseObject) {
            
            NSDictionary *result = responseObject;
            [[DisplayToast sharedManager] dismiss];
            if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
                
                [[DisplayToast sharedManager] showInfoWithStatus:@"New password sent to your email address."];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
                [[DisplayToast sharedManager] showErrorWithStatus:result[RES_KEY_ERROR]];
            }
            
        } failure:^(NSError *error) {
            [[DisplayToast sharedManager] dismiss];
            [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
        }];
        
    } else {
        
        [[DisplayToast sharedManager] showInfoWithStatus:strMessage];
    }
}

#pragma mark - Validation

- (BOOL)loginFromValid {
    if ([_txtEmail.text isEqualToString:@""])
        strMessage = @"Please input email address.";
    else if (![_txtEmail.text isValidEmail])
        strMessage = @"Invalid email address";
    else
        return YES;
    
    return NO;
}

@end
