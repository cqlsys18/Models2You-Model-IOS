//
//  LoginVC.m
//  Models2You
//
//  Created by user on 9/13/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "LoginVC.h"

#import "AccountManager.h"
#import "NSString+emailValidation.h"
#import "SVProgressHUD.h"
#import "WebServiceClient.h"
#import "NSDate+Custom.h"
#import "Utils.h"

#import "DisplayToast.h"

@interface LoginVC ()

@property (nonatomic, strong) NSString *strMessage;

@end

@implementation LoginVC

@synthesize strMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([AccountManager sharedManager].loggedIn) {
        
        [self gotoHomeVC];
    }
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


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[DisplayToast sharedManager] dismiss];
}

#pragma mark - Init

- (void)initUI {
    
    [super initUI];
    
    UIImage *image = [[UIImage imageNamed:@"TextFieldBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    _ivUsernameBack.image = image;
    _ivPasswordBack.image = image;
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _txtEmail)
        [_txtPassword becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - Action Delegate

- (IBAction)actionLogin:(id)sender {

    if ([self loginFormIsValid]) {
        
        [[DisplayToast sharedManager] showWithStatus:@"Validating..."];
        
        [[WebServiceClient sharedClient] loginWithEmail:_txtEmail.text
                                               password:_txtPassword.text
                                                success:^(id responseObject) {
                                                       
                                                       NSDictionary *result = responseObject;
                                                       
                                                       if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
                                                           
                                                           [[DisplayToast sharedManager] dismiss];
                                                           
                                                           AccountManager *manager = [AccountManager sharedManager];
                                                           [manager setLoggedIn:YES];
                                                           [manager setUserId:[result[PARAM_ID] longLongValue]];
                                                           [manager setSessToken:result[PARAM_TOKEN]];
                                                           
                                                           [manager setEmail:_txtEmail.text];
                                                           [manager setPicture:result[PARAM_PICTURE]];
                                                           [manager setName:result[PARAM_NAME]];
                                                           [manager setRate:[result[PARAM_RATE] floatValue]];
                                                           
                                                           [manager setAddress:result[PARAM_ADDRESS]];
                                                           [manager setCity:result[PARAM_CITY]];
                                                           [manager setState:result[PARAM_STATE]];
                                                           [manager setZipcode:result[PARAM_ZIPCODE]];
                                                           
                                                           [manager setPhone:result[PARAM_PHONE]];
                                                           [manager setDob:[NSDate dateFromMysqlDateString:result[PARAM_DOB]]];
                                                           [manager setEyeColor:result[PARAM_EYECOLOR]];
                                                           [manager setHairColor:result[PARAM_HAIRCOLOR]];
                                                           [manager setHeightFoot:[result[PARAM_HEIGHT_FOOT] intValue]];
                                                           [manager setHeightInch:[result[PARAM_HEIGHT_INCH] intValue]];
                                                           [manager setFavorites:result[PARAM_FAVORITES]];
                                                           [manager setAvailability:[result[PARAM_AVAILABILITY] boolValue]];
                                                           
                                                           [manager setSessionTimeOut:[result[PARAM_SESSION_TIME_OUT] intValue]];
                                                           
                                                           [[WebServiceClient sharedClient] initBaseParams];
                                                           
                                                           // update shared value from server api
                                                           [AccountManager sharedManager].availability = [result[PARAM_AVAILABILITY] boolValue];
                                                           
                                                           
                                                           // Update model availability on login
                                                           if(![AccountManager sharedManager].availability){
                                                               [[WebServiceClient sharedClient] setAvailability:true checkAvailabilityDateTime:[NSDate mysqlDateTimeStringFromDate:[NSDate date]] success:^(id responseObject) {
                                                                   
                                                                   NSDictionary *result = responseObject;
                                                                   NSLog(@"%@", result[RES_KEY_SUCCESS]);
                                                                   NSLog(@"%@", result[RES_KEY_ERROR]);
                                                                   
                                                                   if([result[RES_KEY_SUCCESS] intValue] == 1){
                                                                       [AccountManager sharedManager].availability = true;
                                                                   }
                                                                   
                                                                   [self gotoHomeVC];
                                                                   
                                                               } failure:^(NSError *error) {
                                                                   NSLog(@"%@", error);
                                                                   [self gotoHomeVC];
                                                               }];
                                                           }else{
                                                               [self gotoHomeVC];
                                                           }
                                                           
                                                           
                                                           //[self gotoHomeVC];
                                                           
                                                       } else {
                                                           [[DisplayToast sharedManager] dismiss];
                                                           [[DisplayToast sharedManager] showErrorWithStatus:[NSString stringWithFormat:@"%@", result[RES_KEY_ERROR]]];
                                                           
                                                       }
                                                } failure:^(NSError *error) {
                                                       [[DisplayToast sharedManager] dismiss];
                                                    [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
                                                }];
        
    } else {
        [[DisplayToast sharedManager] showInfoWithStatus:strMessage];
    }
}

#pragma mark - Form Validation

- (BOOL)loginFormIsValid {
    
    if ([_txtEmail.text isEqualToString:@""])
        strMessage = @"Please input email address.";
    else if (![_txtEmail.text isValidEmail])
        strMessage = @"Invalid email address";
    else if ([_txtPassword.text isEqualToString:@""])
        strMessage = @"Please input password.";
    else
        return YES;
    
    return NO;
}

#pragma mark - Miscellaneous Function

- (void)gotoHomeVC {
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
