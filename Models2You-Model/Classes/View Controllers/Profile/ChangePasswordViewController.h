//
//  ChangePasswordViewController.h
//  Models2You-Model
//
//  Created by RajeshYadav on 19/04/17.
//  Copyright © 2017 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangePasswordViewControllerDelegate;

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewAlertBg;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;

@property (nonatomic, retain) id<ChangePasswordViewControllerDelegate> delegate;

- (IBAction)actionCancel:(id)sender;
- (IBAction)actionOk:(id)sender;

@end

@protocol ChangePasswordViewControllerDelegate
-(void) removeChangePasswordViewControllerScr;
-(void) removeChangePasswordViewControllerScrWithPassword:(NSString *)password;
@end
