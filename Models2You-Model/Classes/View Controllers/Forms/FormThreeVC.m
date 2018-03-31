//
//  FormThreeVC.m
//  Models2You-Model
//
//  Created by Apple on 24/01/18.
//  Copyright © 2018 Valtus Real Estate, LLC. All rights reserved.
//

#import "FormThreeVC.h"

@interface FormThreeVC ()

@end

@implementation FormThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    viewHeight.constant = nextBtn.frame.origin.y+ nextBtn.frame.size.height;
}

- (IBAction)nxtBtnAction:(id)sender
{
    UIImage * postCardbackImg = [self captureScreenInRect:CGRectMake(0, 0, formThreeView.frame.size.width, formThreeView.frame.size.height)];
    postCardbackImg =  [self imageWithImageONE:postCardbackImg convertToSize:CGSizeMake(formThreeView.frame.size.width, formThreeView.frame.size.height)];
    AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
   // delegate.imgarray = [[NSMutableArray alloc] init];
    [delegate.imgarray addObject:postCardbackImg];
    NSMutableArray * demoarray =[[NSMutableArray alloc]initWithArray:delegate.imgarray];
     nextBtn.hidden = NO;
     bckBtn.hidden = NO;
    for (int i=0; i < demoarray.count; i++)
    {
        UIImage *pdfImg =[[UIImage alloc]initWithData:UIImageJPEGRepresentation([demoarray objectAtIndex:i], 1.0)];
        UIImage *anImage = pdfImg;
        
    }
    FormFourVC *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"FormFourVC"];
    [self.navigationController pushViewController:views animated:YES];
//    FormFourVC *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"FormFourVC"];
//   [self.navigationController pushViewController:views animated:YES];
    
}

-(UIImage *)captureScreenInRect:(CGRect)captureFrame
{
    bckBtn.hidden = YES;
    nextBtn.hidden = YES;
    CALayer *layer;
    layer = formThreeView.layer;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(formThreeView.bounds.size.width, formThreeView.bounds.size.height), NO, 0.0f);//(mainV.bounds.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(UIImage *)imageWithImageONE:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(formThreeView.bounds.size, YES, 2.0);
    // UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)bckBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
