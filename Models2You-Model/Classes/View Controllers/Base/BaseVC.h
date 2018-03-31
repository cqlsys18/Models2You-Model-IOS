//
//  BaseVC.h
//  Models2You
//
//  Created by user on 9/2/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuView.h"

@interface BaseVC : UIViewController <UITextFieldDelegate, MenuViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ivBackFill;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) BOOL showMenuBtn;

@property (nonatomic, strong) UIGestureRecognizer *recognizer;

- (void)initUI;
- (void)tapGestureRecognized:(UIGestureRecognizer *)recognizer;

@end
