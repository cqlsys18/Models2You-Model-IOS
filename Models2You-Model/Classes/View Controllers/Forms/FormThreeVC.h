//
//  FormThreeVC.h
//  Models2You-Model
//
//  Created by Apple on 24/01/18.
//  Copyright © 2018 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayToast.h"
#import "AppDelegate.h"
#import "FormFourVC.h"
#import "textfield.h"
@interface FormThreeVC : UIViewController
{
    IBOutlet UIView *formThreeView;
    IBOutlet NSLayoutConstraint *viewHeight;
    IBOutlet UIButton *bckBtn;
    IBOutlet UIButton *nextBtn;
    
    IBOutlet UIScrollView *formThreeSV;
}
@property(strong,nonatomic)UIImageView * imageOne;
@property(strong,nonatomic)UIImageView * imageTwo;
@property(strong,nonatomic)UIImageView * imageThree;
@end
