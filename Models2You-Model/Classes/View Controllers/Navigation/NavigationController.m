//
//  NavigationController.m
//  Models2You-Model
//
//  Created by user on 10/3/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "NavigationController.h"

#import "HomeVC.h"
#import "BookingListVC.h"
#import "AppDelegate.h"
#import "BookingDetailVC.h"
#import "SVProgressHUD.h"

#import "DisplayToast.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
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

#pragma mark - Navigation Controller Delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[HomeVC class]]) {
        
        if (self.strViewControllerName) {
            
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:self.strViewControllerName];
            
            if ([self.strViewControllerName isEqualToString:@"BookingListVC"]) {
                ((BookingListVC *)vc).bookingCat = self.bookingCat;
                ((BookingListVC *)vc).delegate = viewController;
            }
            
            [self pushViewController:vc animated:YES];
            
            self.strViewControllerName = nil;
        } else {
        
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            if (delegate.bookingId != 0) {
        
                [[DisplayToast sharedManager] dismiss];
        
                BookingDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingDetailVC"];
                vc.bookingId = delegate.bookingId;
                [self pushViewController:vc animated:YES];
                
                delegate.bookingId = 0;
            }
        }
    }
}

@end
