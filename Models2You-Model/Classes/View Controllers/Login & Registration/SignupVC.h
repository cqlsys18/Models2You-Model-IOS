//
//  SignupVC.h
//  Models2You-Model
//
//  Created by user on 9/18/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"
#import "AppDelegate.h"
#import "PECropViewController.h"

@interface SignupVC : BaseVC <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PECropViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivProfile;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileOption1;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileOption2;
@property (weak, nonatomic) IBOutlet UIImageView *ivProfileOption3;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtRate;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtBirthday;
@property (weak, nonatomic) IBOutlet UITextField *txtEyeColor;
@property (weak, nonatomic) IBOutlet UITextField *txtHairColor;
@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtFavorites;
@property (weak, nonatomic) IBOutlet UITextField *txtInstagram;
@property (weak, nonatomic) IBOutlet UITextField *txtFacebook;

@property (weak, nonatomic) IBOutlet UIView *viewDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerTopSpacingConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewHeightPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *heightPicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightPickerTopSpacingConstraint;

- (IBAction)actionPhoto:(id)sender;
- (IBAction)actionBirthday:(id)sender;
- (IBAction)actionDone:(id)sender;
- (IBAction)actionDatePicked:(id)sender;
- (IBAction)actionHeight:(id)sender;
- (IBAction)actionBack:(id)sender;

@end
