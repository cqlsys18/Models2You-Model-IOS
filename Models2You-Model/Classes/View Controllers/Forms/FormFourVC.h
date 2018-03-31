//
//  FormFourVC.h
//  Models2You-Model
//
//  Created by Apple on 24/01/18.
//  Copyright © 2018 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DisplayToast.h"
#import "WebServiceClient.h"
#import "UITextField+Custom.h"
#import "NSString+emailValidation.h"
#import "SVProgressHUD.h"
#import "WebServiceClient.h"
#import "AccountManager.h"
#import "UIImage+dataOfCustomSize.h"
#import "NSDate+Custom.h"
#import <AFNetworking/AFNetworking.h>
#import "Utils.h"
#import "textfield.h"
#import "CaptureSignatureViewController.h"

#define SCREEN_SIZE             [[UIScreen mainScreen]bounds].size
@interface FormFourVC : UIViewController<CaptureSignatureViewDelegate>
{
    NSData  *myPdfData;
    IBOutlet NSLayoutConstraint *viewHeight;
    IBOutlet UIView *formFourView;
     NSString *pdfPath;
    IBOutlet UIScrollView *formFourSV;
    IBOutlet UITextView *signatureTF;
    IBOutlet UIButton *nextBtn;
    IBOutlet UIButton *bckBtn;
    IBOutlet textfield *dateTF;
    NSMutableArray * pdfArray;
    CGSize _pageSize;
}

@property (strong, nonatomic) IBOutlet UIImageView *signatureImageView;
@property(strong,nonatomic)UIImageView * imageOne;
@property(strong,nonatomic)UIImageView * imageTwo;
@property(strong,nonatomic)UIImageView * imageThree;
@property(strong,nonatomic)UIImageView * imageFour;
@end
