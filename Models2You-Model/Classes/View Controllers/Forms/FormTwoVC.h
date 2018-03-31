//
//  FormTwoVC.h
//  Models2You-Model
//
//  Created by Apple on 24/01/18.
//  Copyright © 2018 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayToast.h"
#import "AppDelegate.h"
#import "FormThreeVC.h"
#import "textfield.h"
@interface FormTwoVC : UIViewController
{
    
    IBOutlet UIScrollView *formTwoSV;
    IBOutlet textfield *cityTf;
    IBOutlet textfield *stateTF;
    IBOutlet textfield *zipTF;
    IBOutlet textfield *accountNoTF;
    IBOutlet UITextView *addTextV;
    IBOutlet UITextField *socilaSecurityTF_One;
    IBOutlet UITextField *socilaSecurityTF_Two;
    IBOutlet UITextField *socilaSecurityTF_Three;
    IBOutlet UITextField *socilaSecurityTF_Four;
    IBOutlet UITextField *socilaSecurityTF_Five;
    IBOutlet UITextField *socilaSecurityTF_Six;
    IBOutlet UITextField *socilaSecurityTF_Seven;
    IBOutlet UITextField *socilaSecurityTF_Eight;
    IBOutlet UITextField *socilaSecurityTF_Nine;
    IBOutlet UITextField *empIdentificationTF_One;
    IBOutlet UITextField *empIdentificationTF_Two;
    IBOutlet UITextField *empIdentificationTF_Three;
    IBOutlet UITextField *empIdentificationTF_Four;
    IBOutlet UITextField *empIdentificationTF_Five;
    IBOutlet UITextField *empIdentificationTF_Six;
    IBOutlet UITextField *empIdentificationTF_Seven;
    IBOutlet UITextField *empIdentificationTF_Eight;
    IBOutlet UITextField *empIdentificationTF_Nine;
    
    IBOutlet UIButton *nextBtn;
    
    IBOutlet UIButton *backBtn;
    IBOutlet NSLayoutConstraint *viewHeight;
}
@property(strong,nonatomic)UIImageView * imageOne;
@property(strong,nonatomic)UIImageView * imageTwo;
@end
