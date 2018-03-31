//
//  FormOneVC.m
//  Models2You-Model
//
//  Created by Apple on 24/01/18.
//  Copyright © 2018 Valtus Real Estate, LLC. All rights reserved.
//

#import "FormOneVC.h"

@interface FormOneVC ()

@end

@implementation FormOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    taxStr = @"";
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    ViewHeight.constant = nextBtn.frame.origin.y+ nextBtn.frame.size.height + 40;
}
- (IBAction)otherSelectBtn:(id)sender
{
    taxStr = @"other";
    individualcheckBtn.selected = NO;
    c_corporationselectBtn.selected = NO;
    PartnershipselectBtn.selected = NO;
    s_corporationselectBtn.selected = NO;
    trustEstateselectBtn.selected = NO;
    limitedSelectBtn.selected = NO;
    otherSelctBtn.selected = YES;
}

- (IBAction)nextBtnAction:(id)sender
{
    if ([nameT.text isEqualToString:@""])
    {
         [[DisplayToast sharedManager] showInfoWithStatus:@"Add name"];
    }
    else if ([businessNameTF.text isEqualToString:@""])
    {
         [[DisplayToast sharedManager] showInfoWithStatus:@"Add Business name"];
    }
    else if ([addressTF.text isEqualToString:@""])
    {
         [[DisplayToast sharedManager] showInfoWithStatus:@"Add address"];
    }
    else if ([taxStr isEqualToString:@""])
    {
         [[DisplayToast sharedManager] showInfoWithStatus:@"select one type"];
    }
    else
    {
        
    UIImage * postCardbackImg = [self captureScreenInRect:CGRectMake(0, 0, formOneView.frame.size.width, formOneView.frame.size.height)];
    postCardbackImg =  [self imageWithImageONE:postCardbackImg convertToSize:CGSizeMake(formOneView.frame.size.width, formOneView.frame.size.height)];
    AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
    delegate.imgarray = [[NSMutableArray alloc] init];
    [delegate.imgarray addObject:postCardbackImg];
    NSMutableArray * demoarray =[[NSMutableArray alloc]initWithArray:delegate.imgarray];
    nextBtn.hidden = NO;
    for (int i=0; i < demoarray.count; i++)
    {
    UIImage *pdfImg =[[UIImage alloc]initWithData:UIImageJPEGRepresentation([demoarray objectAtIndex:i], 1.0)];
    UIImage *anImage = pdfImg;
    FormTwoVC *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"FormTwoVC"];
        views.imageOne.image = anImage;
    [self.navigationController pushViewController:views animated:YES];
    }
}
}
- (IBAction)individualChkBtn:(id)sender {
      taxStr = @"individual";
    individualcheckBtn.selected = YES;
    c_corporationselectBtn.selected = NO;
    PartnershipselectBtn.selected = NO;
    s_corporationselectBtn.selected = NO;
    trustEstateselectBtn.selected = NO;
    limitedSelectBtn.selected = NO;
    otherSelctBtn.selected = NO;
}
- (IBAction)c_corporationCheckBtn:(id)sender {
    taxStr = @"individual";
    individualcheckBtn.selected = NO;
    c_corporationselectBtn.selected = YES;
    PartnershipselectBtn.selected = NO;
    s_corporationselectBtn.selected = NO;
    trustEstateselectBtn.selected = NO;
    limitedSelectBtn.selected = NO;
    otherSelctBtn.selected = NO;
}
- (IBAction)trustEstateBNtn:(id)sender {
    taxStr = @"individual";
    individualcheckBtn.selected = NO;
    c_corporationselectBtn.selected = NO;
    PartnershipselectBtn.selected = NO;
    s_corporationselectBtn.selected = NO;
    trustEstateselectBtn.selected = YES;
    limitedSelectBtn.selected = NO;
    otherSelctBtn.selected = NO;
}
- (IBAction)s_CorporationSelectBt:(id)sender {
    taxStr = @"individual";
    individualcheckBtn.selected = NO;
    c_corporationselectBtn.selected = NO;
    PartnershipselectBtn.selected = NO;
    s_corporationselectBtn.selected = YES;
    trustEstateselectBtn.selected = NO;
    limitedSelectBtn.selected = NO;
    otherSelctBtn.selected = NO;
}
- (IBAction)parternershipSelectBtn:(id)sender {
    taxStr = @"individual";
    individualcheckBtn.selected = NO;
    c_corporationselectBtn.selected = NO;
    PartnershipselectBtn.selected = YES;
    s_corporationselectBtn.selected = NO;
    trustEstateselectBtn.selected = NO;
    limitedSelectBtn.selected = NO;
    otherSelctBtn.selected = NO;
}
- (IBAction)limitedSelectBtn:(id)sender {
    taxStr = @"individual";
    individualcheckBtn.selected = NO;
    c_corporationselectBtn.selected = NO;
    PartnershipselectBtn.selected = NO;
    s_corporationselectBtn.selected = NO;
    trustEstateselectBtn.selected = NO;
    limitedSelectBtn.selected = YES;
    otherSelctBtn.selected = NO;
}

- (IBAction)bckBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(UIImage *)captureScreenInRect:(CGRect)captureFrame
{
    nextBtn.hidden = YES;
    CALayer *layer;
    layer = formOneView.layer;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(formOneView.bounds.size.width, formOneView.bounds.size.height), NO, 0.0f);//(mainV.bounds.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(UIImage *)imageWithImageONE:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
     UIGraphicsBeginImageContextWithOptions(formOneView.bounds.size, YES, 2.0);
    // UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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
