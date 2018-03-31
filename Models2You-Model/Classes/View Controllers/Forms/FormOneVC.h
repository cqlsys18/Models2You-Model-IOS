//
//  FormOneVC.h
//  Models2You-Model
//
//  Created by Apple on 24/01/18.
//  Copyright © 2018 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayToast.h"
#import "AppDelegate.h"
#import "FormTwoVC.h"
#import "textfield.h"
@interface FormOneVC : UIViewController
{
    
    IBOutlet UIView * formOneView;
    IBOutlet UIScrollView *formOneSV;
    IBOutlet NSLayoutConstraint *ViewHeight;
    IBOutlet textfield *nameT;
    IBOutlet textfield *businessNameTF;
    IBOutlet UIButton *individualcheckBtn;
    IBOutlet UIButton *c_corporationselectBtn;
    IBOutlet UIButton *PartnershipselectBtn;
    
    IBOutlet UIButton *s_corporationselectBtn;
    IBOutlet UIButton *trustEstateselectBtn;
    IBOutlet UIButton *limitedSelectBtn;
    IBOutlet UIButton *otherSelctBtn;
    IBOutlet textfield *exemptPayeeCodeTF;
    NSString * taxStr;
    IBOutlet textfield *addressTF;
    IBOutlet textfield *exemptionFromFATCA_TF;
    IBOutlet UIButton *nextBtn;
}
@end
