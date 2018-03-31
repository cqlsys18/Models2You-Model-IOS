//
//  FormTwoVC.m
//  Models2You-Model
//
//  Created by Apple on 24/01/18.
//  Copyright © 2018 Valtus Real Estate, LLC. All rights reserved.
//

#import "FormTwoVC.h"

@interface FormTwoVC ()
{
    IBOutlet UIView *formView;
    IBOutlet UIView *textV;
    
}
@end

@implementation FormTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    textV.layer.cornerRadius = 4;
    textV.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    textV.layer.borderWidth = 1;
    textV.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    viewHeight.constant = nextBtn.frame.origin.y+ nextBtn.frame.size.height +20;
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)nextBtnAction:(id)sender
{
    if ([cityTf.text isEqualToString:@""])
    {
        [[DisplayToast sharedManager] showInfoWithStatus:@"Add City"];
    }
    else if ([stateTF.text isEqualToString:@""])
    {
        [[DisplayToast sharedManager] showInfoWithStatus:@"Add State"];
    }
    else if ([zipTF.text isEqualToString:@""])
    {
        [[DisplayToast sharedManager] showInfoWithStatus:@"Add Zip"];
    }
   
    else
    {
        UIImage * postCardbackImg = [self captureScreenInRect:CGRectMake(0, 0, formView.frame.size.width, formView.frame.size.height)];
        postCardbackImg =  [self imageWithImageONE:postCardbackImg convertToSize:CGSizeMake(formView.frame.size.width, formView.frame.size.height)];
        AppDelegate * delegate =(AppDelegate*) [UIApplication sharedApplication].delegate;
      //  delegate.imgarray = [[NSMutableArray alloc] init];
        [delegate.imgarray addObject:postCardbackImg];
        NSMutableArray * demoarray =[[NSMutableArray alloc]initWithArray:delegate.imgarray];
        nextBtn.hidden = NO;
        backBtn.hidden = NO;
        for (int i=0; i < demoarray.count; i++)
        {
            UIImage *pdfImg =[[UIImage alloc]initWithData:UIImageJPEGRepresentation([demoarray objectAtIndex:i], 1.0)];
            UIImage *anImage = pdfImg;
        }
        FormThreeVC *views        = [self.storyboard instantiateViewControllerWithIdentifier:@"FormThreeVC"];
        [self.navigationController pushViewController:views animated:YES];
    }
}


-(UIImage *)captureScreenInRect:(CGRect)captureFrame
{
    nextBtn.hidden = YES;
    backBtn.hidden = YES;
    CALayer *layer;
    layer = formView.layer;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(formView.bounds.size.width, formView.bounds.size.height), NO, 0.0f);//(mainV.bounds.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(UIImage *)imageWithImageONE:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(formView.bounds.size, YES, 2.0);
    // UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = newString.length;
    
    
    if (textField == socilaSecurityTF_One) {
        if (newLength == 1) {
            [socilaSecurityTF_One setText:newString];
            [socilaSecurityTF_Two becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == socilaSecurityTF_Two) {
        if (newLength == 1) {
            [socilaSecurityTF_Two setText:newString];
            [socilaSecurityTF_Three becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == socilaSecurityTF_Three) {
        if (newLength == 1) {
            [socilaSecurityTF_Three setText:newString];
            [socilaSecurityTF_Four becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == socilaSecurityTF_Four) {
        if (newLength == 1) {
            [socilaSecurityTF_Four setText:newString];
            [socilaSecurityTF_Five becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == socilaSecurityTF_Five) {
        if (newLength == 1) {
            [socilaSecurityTF_Five setText:newString];
            [socilaSecurityTF_Six becomeFirstResponder];
            return NO;
        }
    }else if (textField == socilaSecurityTF_Six) {
        if (newLength == 1) {
            [socilaSecurityTF_Six setText:newString];
            [socilaSecurityTF_Seven becomeFirstResponder];
            return NO;
        }
    }else if (textField == socilaSecurityTF_Seven) {
        if (newLength == 1) {
            [socilaSecurityTF_Seven setText:newString];
            [socilaSecurityTF_Eight becomeFirstResponder];
            return NO;
        }
    }else if (textField == socilaSecurityTF_Eight) {
        if (newLength == 1) {
            [socilaSecurityTF_Eight setText:newString];
            [socilaSecurityTF_Nine becomeFirstResponder];
            return NO;
        }
    }
    
    else if (textField == socilaSecurityTF_Nine){
        if ([socilaSecurityTF_One.text isEqualToString:@""] || [socilaSecurityTF_Two.text isEqualToString:@""] || [socilaSecurityTF_Three.text isEqualToString:@""] || [socilaSecurityTF_Four.text isEqualToString:@""] || [socilaSecurityTF_Five.text isEqualToString:@""] || [socilaSecurityTF_Six.text isEqualToString:@""] || [socilaSecurityTF_Seven.text isEqualToString:@""] || [socilaSecurityTF_Eight.text isEqualToString:@""])
        {
            [socilaSecurityTF_One becomeFirstResponder];
            return  NO;
            
        }
        else {
            [socilaSecurityTF_Nine setText:newString];
            [self.view endEditing:YES];
        }
    }
    
    else if (textField == empIdentificationTF_One) {
        if (newLength == 1) {
            [empIdentificationTF_One setText:newString];
            [empIdentificationTF_Two becomeFirstResponder];
            return NO;
        }
    }
    
    else if (textField == empIdentificationTF_Two) {
        if (newLength == 1) {
            [empIdentificationTF_Two setText:newString];
            [empIdentificationTF_Three becomeFirstResponder];
            return NO;
        }
    }
    
    else if (textField == empIdentificationTF_Three) {
        if (newLength == 1) {
            [empIdentificationTF_Three setText:newString];
            [empIdentificationTF_Four becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == empIdentificationTF_Four) {
        if (newLength == 1) {
            [empIdentificationTF_Four setText:newString];
            [empIdentificationTF_Five becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == empIdentificationTF_Five) {
        if (newLength == 1) {
            [empIdentificationTF_Five setText:newString];
            [empIdentificationTF_Six becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == empIdentificationTF_Six) {
        if (newLength == 1) {
            [empIdentificationTF_Six setText:newString];
            [empIdentificationTF_Seven becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == empIdentificationTF_Seven) {
        if (newLength == 1) {
            [empIdentificationTF_Seven setText:newString];
            [empIdentificationTF_Eight becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == empIdentificationTF_Eight) {
        if (newLength == 1) {
            [empIdentificationTF_Eight setText:newString];
            [empIdentificationTF_Nine becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == empIdentificationTF_Nine){
        if ([empIdentificationTF_One.text isEqualToString:@""] || [empIdentificationTF_Two.text isEqualToString:@""] || [empIdentificationTF_Three.text isEqualToString:@""] || [empIdentificationTF_Four.text isEqualToString:@""] || [empIdentificationTF_Five.text isEqualToString:@""] || [empIdentificationTF_Six.text isEqualToString:@""] || [empIdentificationTF_Seven.text isEqualToString:@""] || [empIdentificationTF_Eight.text isEqualToString:@""])
        {
            [empIdentificationTF_One becomeFirstResponder];
            return  NO;
            
        }
        else {
            [empIdentificationTF_Nine setText:newString];
            [self.view endEditing:YES];
        }
    }
    return YES;
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
