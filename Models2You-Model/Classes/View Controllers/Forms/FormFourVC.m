//
//  FormFourVC.m
//  Models2You-Model
//
//  Created by Apple on 24/01/18.
//  Copyright © 2018 Valtus Real Estate, LLC. All rights reserved.
//

#import "FormFourVC.h"
#import "CaptureSignatureViewController.h"
@interface FormFourVC ()

@end

@implementation FormFourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    pdfArray =[[NSMutableArray alloc]init];
    CGFloat borderWidth = 2.0f;
    
    self.signatureImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.signatureImageView.layer.borderWidth = borderWidth;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(void)viewDidLayoutSubviews
{
    viewHeight.constant = nextBtn.frame.origin.y+ nextBtn.frame.size.height+120;
}

- (IBAction)nxtBtnAction:(id)sender
{
    UIImage * postCardbackImg = [self captureScreenInRect:CGRectMake(0, 0, formFourView.frame.size.width, formFourView.frame.size.height)];
    postCardbackImg =  [self imageWithImageONE:postCardbackImg convertToSize:CGSizeMake(formFourView.frame.size.width, formFourView.frame.size.height)];
    AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    //   delegate.imgarray = [[NSMutableArray alloc] init];
    [delegate.imgarray addObject:postCardbackImg];
    NSMutableArray * demoarray =[[NSMutableArray alloc]initWithArray:delegate.imgarray];
    nextBtn.hidden = NO;
    bckBtn.hidden = NO;
    [self setupPDFDocumentNamed:[NSString stringWithFormat:@"%@%d",@"PostCard"] Width:formFourView.bounds.size.width Height:formFourView.bounds.size.height];
    
    for (int i=0; i < demoarray.count; i++)
    {
        UIImage *pdfImg =[[UIImage alloc]initWithData:UIImageJPEGRepresentation([demoarray objectAtIndex:i], 1.0)];
        UIImage *anImage = pdfImg;
        [self beginPDFPage];
        CGRect imageRect = [self addImage:anImage atPoint:CGPointMake(0, 0)];
    }
    [self finishPDF];
    [self signUp];
    // FormFourVC *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"FormFourVC"];
    // [self.navigationController pushViewController:views animated:YES];
}

-(void)signUp
{
    NSURL *localURL = [NSURL fileURLWithPath:pdfPath];
    myPdfData = [NSData dataWithContentsOfFile:pdfPath];
    
    AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    NSMutableDictionary * signUpDataDic = [[NSMutableDictionary alloc] initWithDictionary:[delegate.signUpDataDic objectForKey:@"signDic"]];
    int heightFoot = [[signUpDataDic objectForKey:@"heightFoot"] intValue];
    int heightInch = [[signUpDataDic objectForKey:@"heightInch"] intValue];
    [[DisplayToast sharedManager] showWithStatus:@"Registering..."];
    
    [[WebServiceClient sharedClient]registerWithEmail:[signUpDataDic objectForKey:@"email"] password:[signUpDataDic objectForKey:@"pass"] photo:[signUpDataDic objectForKey:@"photo"] photoOption1:[signUpDataDic objectForKey:@"picOne"] photoOption2:[signUpDataDic objectForKey:@"picTwo"] photoOption3:[signUpDataDic objectForKey:@"picThree"] name:[signUpDataDic objectForKey:@"name"] rate:50.0 address:[signUpDataDic objectForKey:@"address"] city:[signUpDataDic objectForKey:@"city"] state:[signUpDataDic objectForKey:@"state"] zipcode:[signUpDataDic objectForKey:@"zipcode"] phone:[signUpDataDic objectForKey:@"phone"] dob:[signUpDataDic objectForKey:@"dob"] eyeColor:[signUpDataDic objectForKey:@"eyeColor"] hairColor:[signUpDataDic objectForKey:@"hairColor"] heightFoot:heightFoot heightInch:heightInch favorites:[signUpDataDic objectForKey:@"favorites"] instagramId:[signUpDataDic objectForKey:@"instagramId"] facebookId:[signUpDataDic objectForKey:@"facebookId"] pdf:myPdfData success:^(id responseObject)
    {
        NSDictionary *result = responseObject;
        
        if ([result[RES_KEY_SUCCESS] isEqualToNumber:RES_VALUE_SUCCESS]) {
            [[DisplayToast sharedManager] dismiss];
            [[DisplayToast sharedManager] showInfoWithStatus:@"Registered successfully."];
            UIViewController *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.navigationController pushViewController:views animated:YES];
            //  [self.navigationController popViewControllerAnimated:YES];
        } else {
            [[DisplayToast sharedManager] dismiss];
            [[DisplayToast sharedManager] showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", result[RES_KEY_ERROR], result[RES_KEY_ERROR_MESSAGES]]];
        }
    } failure:^(NSError *error) {
        [[DisplayToast sharedManager] dismiss];
        [[DisplayToast sharedManager] showErrorWithStatus:error.localizedDescription];
        
        NSError *underlyingError = error.userInfo[@"NSUnderlyingError"];
        NSLog(@"%@", [[NSString alloc] initWithData:underlyingError.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]);
    }];
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
}

-(NSString*)getPDFFileName
{
    NSString* pdfFileName = pdfPath ;
    return pdfFileName;
}

- (IBAction)bckBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)signatureBt:(id)sender
{
    CaptureSignatureViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"CaptureSignatureViewController"];
    view.delegate = self;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark
#pragma mark text field delegates

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect TimePickerFrame    = CGRectMake(0,250,0,0);
    UIDatePicker * TimePicker = [[UIDatePicker alloc]initWithFrame:TimePickerFrame];
    TimePicker.datePickerMode = UIDatePickerModeDate;
    [TimePicker addTarget:self action:@selector(DatePicer:) forControlEvents:UIControlEventValueChanged];
    [dateTF setInputView:TimePicker];
}


-(void) DatePicer:(UIDatePicker*)picker
{
    [picker setMinimumDate: [NSDate date]];
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-YYYY"];
    NSString * dateString = [dateFormat stringFromDate:picker.date];
    dateTF.text          = [NSString stringWithFormat:@"%@",dateString];
}

-(UIImage *)captureScreenInRect:(CGRect)captureFrame
{
    nextBtn.hidden = YES;
     bckBtn.hidden = YES;
    CALayer *layer;
    layer = formFourView.layer;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(formFourView.bounds.size.width, formFourView.bounds.size.height), NO, 0.0f);//(mainV.bounds.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(UIImage *)imageWithImageONE:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(formFourView.bounds.size, YES, 2.0);
    // UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point {
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [image drawInRect:imageFrame];
    return imageFrame;
}


#pragma  mark
#pragma mark PDF create
- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
    
    if (SCREEN_SIZE.width == 320) {
        _pageSize = CGSizeMake(width*2, height*2);
    }else if (SCREEN_SIZE.width == 375)
    {
        _pageSize = CGSizeMake(width*2, height*2);
    }else if (SCREEN_SIZE.width == 414){
        _pageSize = CGSizeMake(width*3, height*3);
    }
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
    
    
    NSDictionary *dict = @{
                           @"Path" :pdfPath,
                           @"Name" :name
                           };
    
    [pdfArray addObject:dict];
   
    NSLog(@"YES");

    
//    NSURL *documentsURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
//                                                                 inDomain:NSUserDomainMask
//                                                        appropriateForURL:nil
//                                                                   create:NO
//                                                                    error:nil];
//    NSURL *cafURL = [documentsURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf", name]];
//
//   NSData *audioData = [NSData dataWithContentsOfFile:cafURL];
//
//
//    NSError *error;
//  //  myPdfData = [NSData dataWithContentsOfURL:pdfPath options:nil error:&error];
//
//    NSLog(@"%@",error);
//
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:pdfPath];
    
    AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    delegate.pdfArrayData = [[NSMutableArray alloc] initWithArray:pdfArray];
    
}

- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}


- (void)processCompleted:(UIImage*)signImage
{
    _signatureImageView.image = signImage;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"view_to_capture"]) {
        CaptureSignatureViewController *destination = segue.destinationViewController;
        destination.delegate = self;
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

@end
