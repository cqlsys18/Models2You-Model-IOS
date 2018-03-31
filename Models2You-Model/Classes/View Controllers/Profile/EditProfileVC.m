//
//  ViewController.m
//  Models2You-Model
//
//  Created by user on 9/14/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "EditProfileVC.h"

#import "AccountManager.h"
#import "SVProgressHUD.h"
#import "WebServiceClient.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "Utils.h"

#import "DisplayToast.h"

#import "ChangePasswordViewController.h"

@interface EditProfileVC () <ChangePasswordViewControllerDelegate>

@property (nonatomic, strong) NSString *strMessage;
@property (nonatomic, strong) NSString *strPicture;

@end

@implementation EditProfileVC{
    ChangePasswordViewController *_changePasswordViewController;
}

@synthesize strMessage, strPicture;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initUI {
    
    self.showMenuBtn = YES;
    
    [super initUI];
    
    _ivProfile.layer.cornerRadius = 16;
    
    [self setBackImage:_ivNameBack];
    [self setBackImage:_ivHairColorBack];
    [self setBackImage:_ivFavoritesBack];
    [self setBackImage:_ivHeightBack];
    [self setBackImage:_ivEyeColorBack];
    [self setBackImage:_ivRateBack];
    
    AccountManager *manager = [AccountManager sharedManager];

    _txtName.text = manager.name;
    _txtRate.text = [NSString stringWithFormat:@"%.2f", manager.rate];
    _txtHairColor.text = manager.hairColor;
    _txtFavorites.text = manager.favorites;
    _txtEyeColor.text = manager.eyeColor;
    _txtHeight.text = [NSString stringWithFormat:@"%d' %d\"", manager.heightFoot, manager.heightInch];
    strPicture = manager.picture;
    
    [_heightPicker selectRow:manager.heightFoot - 4 inComponent:0 animated:NO];
    [_heightPicker selectRow:manager.heightInch inComponent:1 animated:NO];
    
    [_ivProfile setImageWithURL:[NSURL URLWithString:strPicture] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

- (void)setBackImage:(UIImageView *)view {
    view.image = [[UIImage imageNamed:@"TextFieldBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

-(void) updateNewPassword:(NSString *)newPassword{
    [[DisplayToast sharedManager] showWithStatus:@"Updating..."];
    
    // updatePasswordInfo
    [[WebServiceClient sharedClient] updatePasswordInfo:newPassword success:^(id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@", result[RES_KEY_SUCCESS]);
        NSLog(@"%@", result[RES_KEY_ERROR]);
        
        if([result[RES_KEY_SUCCESS] intValue] == 1){
            [[DisplayToast sharedManager] showInfoWithStatus:@"Password Change successfully."];
        }else{
            [[DisplayToast sharedManager] showErrorWithStatus:result[RES_KEY_ERROR]];
        }

    } failure:^(NSError *error) {
        [[DisplayToast sharedManager] dismiss];
        [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - Tap Gesture Delegate

- (void)tapGestureRecognized:(UIGestureRecognizer *)recognizer {
    [super tapGestureRecognized:recognizer];
    
    [self setHeightPickerHidden:YES];
    
    [[DisplayToast sharedManager] dismiss];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _txtName)
        [_txtRate becomeFirstResponder];
    else if (textField == _txtRate)
        [_txtHairColor becomeFirstResponder];
    else if (textField == _txtHairColor)
        [_txtFavorites becomeFirstResponder];
    else if (textField == _txtFavorites)
        [_txtEyeColor becomeFirstResponder];
    else
        [textField resignFirstResponder];
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [super textFieldDidBeginEditing:textField];
    
    [self setHeightPickerHidden:YES];
}

#pragma mark - Action Delegate

- (IBAction)pickerhidden:(id)sender {
     [self setHeightPickerHidden:YES];
}


- (IBAction)actionUpdate:(id)sender {
    
    if ([self isFormValid]) {
        
        [[DisplayToast sharedManager] showWithStatus:@"Updating..."];
        
        [[WebServiceClient sharedClient] updateProfileWithName:_txtName.text
                                                          rate:[_txtRate.text floatValue]
                                                     hairColor:_txtHairColor.text
                                                     favorites:_txtFavorites.text
                                                    heightFoot:[_heightPicker selectedRowInComponent:0] + 4
                                                    heightInch:[_heightPicker selectedRowInComponent:1]
                                                      eyeColor:_txtEyeColor.text
                                                         photo:strPicture
                                                       success:^(id responseObject) {
                                                           
                                                           NSDictionary *result = responseObject;
                                                           
                                                           if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
                                                               
                                                               [[DisplayToast sharedManager] dismiss];
                                                               
                                                               AccountManager *manager = [AccountManager sharedManager];
                                                               
                                                               manager.name = _txtName.text;
                                                               manager.rate = [_txtRate.text floatValue];
                                                               manager.hairColor = _txtHairColor.text;
                                                               manager.favorites = _txtFavorites.text;
                                                               manager.heightFoot = [_heightPicker selectedRowInComponent:0] + 4;
                                                               manager.heightInch = [_heightPicker selectedRowInComponent:1];
                                                               manager.eyeColor = _txtEyeColor.text;
                                                               
                                                               manager.picture = strPicture;
                                                               
                                                           } else {
                                                               [[DisplayToast sharedManager] dismiss];
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

- (IBAction)actionHeight:(id)sender {
    [self.view endEditing:YES];
    
    [self setHeightPickerHidden:NO];

}

- (IBAction)actionPhoto:(id)sender {
    
    SelectPhotoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectPhotoVC"];
    vc.delegate = self;
    vc.strPicture = strPicture;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionHome:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionUpdatePassword:(id)sender{
    //
    if(_changePasswordViewController == nil){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        _changePasswordViewController = (ChangePasswordViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"ChangePasswordViewController"];
        
        _changePasswordViewController.delegate = self;
        
        [self.view addSubview:_changePasswordViewController.view];
    }
}

#pragma mark - Select Photo View Delegate

- (void)photoPicked:(NSString *)strUrl {
    
    strPicture = strUrl;
    
    [_ivProfile sd_cancelCurrentImageLoad];
    [_ivProfile removeActivityIndicator];
    _ivProfile.image = nil;
    
    [_ivProfile setImageWithURL:[NSURL URLWithString:strPicture] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return 3;
    
    return 12;
}

#pragma mark - Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0)
        return [NSString stringWithFormat:@"%d'", row + 4];
    
    return [NSString stringWithFormat:@"%d\"", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int foot = [pickerView selectedRowInComponent:0] + 4;
    int inch = [pickerView selectedRowInComponent:1];
    
    _txtHeight.text = [NSString stringWithFormat:@"%d' %d\"", foot, inch];
}

#pragma mark - Height Picker Show/Hide

- (void)setHeightPickerHidden:(BOOL)hidden {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = _viewHeightPicker.frame;
        
        if (hidden) {
            frame.origin.y = self.view.frame.size.height;
            _heightPickerTopSpacingConstraint.constant = 0;
        } else {
            frame.origin.y = self.view.frame.size.height - frame.size.height;
            _heightPickerTopSpacingConstraint.constant = -frame.size.height;
        }
        
        _viewHeightPicker.frame = frame;
        
    }];
}

#pragma mark - Miscellaneous Functions

- (BOOL)isFormValid {
    
    if ([_txtName.text isEqualToString:@""])
        strMessage = @"Please input name.";
    else if ([_txtRate.text isEqualToString:@""])
        strMessage = @"Please input hourly rate.";
    else if ([_txtRate.text componentsSeparatedByString:@"."].count > 2)
        strMessage = @"Invalid hourly rate.";
    else if ([_txtRate.text floatValue] < 50)
        strMessage = @"Hourly rate cannot be lower than $50.";
    else if ([_txtHairColor.text isEqualToString:@""])
        strMessage = @"Please input hair color.";
    else if ([_txtFavorites.text isEqualToString:@""])
        strMessage = @"Please input hobbies.";
    else if ([_txtEyeColor.text isEqualToString:@""])
        strMessage = @"Please input eye color.";
    else
        return YES;
    
    return NO;
}

#pragma mark - ChangePasswordViewControllerDelegate method implementation
-(void) removeChangePasswordViewControllerScr{
    _changePasswordViewController.delegate = nil;
    [_changePasswordViewController.view removeFromSuperview];
    _changePasswordViewController = nil;
}

-(void) removeChangePasswordViewControllerScrWithPassword:(NSString *)password{
    [self removeChangePasswordViewControllerScr];
    [self updateNewPassword:password];
}
@end
