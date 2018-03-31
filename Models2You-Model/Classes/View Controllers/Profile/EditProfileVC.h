//
//  ViewController.h
//  Models2You-Model
//
//  Created by user on 9/14/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

#import "SelectPhotoVC.h"

@interface EditProfileVC : BaseVC <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SelectPhotoViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivProfile;

@property (weak, nonatomic) IBOutlet UIImageView *ivNameBack;
@property (weak, nonatomic) IBOutlet UIImageView *ivHairColorBack;
@property (weak, nonatomic) IBOutlet UIImageView *ivFavoritesBack;
@property (weak, nonatomic) IBOutlet UIImageView *ivHeightBack;
@property (weak, nonatomic) IBOutlet UIImageView *ivEyeColorBack;
@property (weak, nonatomic) IBOutlet UIImageView *ivRateBack;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtHairColor;
@property (weak, nonatomic) IBOutlet UITextField *txtFavorites;
@property (weak, nonatomic) IBOutlet UITextField *txtHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtEyeColor;
@property (weak, nonatomic) IBOutlet UITextField *txtRate;

@property (weak, nonatomic) IBOutlet UIView *viewHeightPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *heightPicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightPickerTopSpacingConstraint;

- (IBAction)actionUpdate:(id)sender;
- (IBAction)actionHeight:(id)sender;
- (IBAction)actionPhoto:(id)sender;
- (IBAction)actionHome:(id)sender;
- (IBAction)actionUpdatePassword:(id)sender;

@end

