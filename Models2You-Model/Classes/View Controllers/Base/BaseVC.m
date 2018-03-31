//
//  BaseVC.m
//  Models2You
//
//  Created by user on 9/2/15.
//  Copyright (c) 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "BaseVC.h"

#import "AccountManager.h"
#import "HomeVC.h"
#import "BookingListVC.h"
#import "NavigationController.h"
#import "EditProfileVC.h"
#import "Config.h"
#import "WebServiceClient.h"
#import "ManagePhotoVC.h"
#import "AppDelegate.h"

@interface BaseVC ()

@property (nonatomic, strong) UIButton *btnMenu;
@property (nonatomic, strong) UIView *activeField;
@property (nonatomic, strong) UIButton *btnLogo;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) MenuView *menuView;

@end

@implementation BaseVC

@synthesize activeField, recognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
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

#pragma mark - Init

- (void)initUI {
    
    [_ivBackFill setImage:[UIImage imageNamed:@"BackFill"]];
    if (self.showMenuBtn) {
        _btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 13 - 32, 50, 32, 30)];
        [_btnMenu setImage:[UIImage imageNamed:@"MenuBtn"] forState:UIControlStateNormal];
        [self.view addSubview:_btnMenu];
        [_btnMenu addTarget:self action:@selector(actionShowMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.view addGestureRecognizer:recognizer];
    if ([_scrollView isKindOfClass:[UITableView class]]) {
        ((UITableView *)_scrollView).tableFooterView = [UIView new];
    }
    [self registerForKeyboardNotifications];
    CGRect frame = self.view.frame;
    // Logo Button
    if ([AccountManager sharedManager].loggedIn) {
        _btnLogo = [[UIButton alloc] initWithFrame:CGRectMake(10 / 320.f * frame.size.width, 25, 169 / 320.f * frame.size.width, 47)];
        [_btnLogo addTarget:self action:@selector(actionLogo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnLogo];
    }
    // Cover View
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _coverView.hidden = YES;
    UIGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu:)];
    [_coverView addGestureRecognizer:gr];
    [self.view addSubview:_coverView];
    
    // Menu View
    _menuView = (MenuView *)[[[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:nil options:nil] objectAtIndex:0];
    _menuView.delegate = self;
    _menuView.hidden = YES;
    
    gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu:)];
    [_menuView addGestureRecognizer:gr];
    CGRect frameMenuView = _menuView.frame;
    frameMenuView.origin.y = 50;
    frameMenuView.origin.x = frame.size.width - 183;
    _menuView.frame = frameMenuView;
    [self.view addSubview:_menuView];
}

#pragma mark - Tap Gesture Recognizer

- (void)tapGestureRecognized:(UIGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

- (void)hideMenu:(UIGestureRecognizer *)recognizer {
    _coverView.hidden = YES;
    _menuView.hidden = YES;
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    activeField = nil;
    if (!textField.isSecureTextEntry) {
        textField.text = [[textField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    activeField = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    activeField = nil;
    
//    if (!textView.isSecureTextEntry) {
//        textView.text = [[textView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    }
}

#pragma mark - Keyboard Notification Handle

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self inputWasShown:kbSize.height];
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self inputWillBeHidden];
}

- (void)inputWasShown:(CGFloat)inputHeight {
    
    //NSLog(@"Active Field: %@", activeField);
    
    //_contentInset = self.tblView.contentInset;
    //_scrollInset = self.tblView.scrollIndicatorInsets;
    
    CGRect rect = [self.scrollView.superview convertRect:self.scrollView.frame toView:self.view];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, inputHeight - MIN(inputHeight, (self.view.frame.size.height - (rect.origin.y + rect.size.height))), 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= inputHeight;
    
    CGPoint point = [activeField.superview convertPoint:CGPointMake(0, activeField.frame.origin.y + activeField.frame.size.height) toView:self.view];
    CGRect frame = [activeField.superview convertRect:activeField.frame toView:self.scrollView];
    
    if (!CGRectContainsPoint(aRect, point) ) {
        [self.scrollView scrollRectToVisible:frame animated:YES];
    }
    
}

- (void)inputWillBeHidden {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
}

#pragma mark - Action Delegate

- (void)actionLogo {
    
    if ([AccountManager sharedManager].loggedIn) {
    
        [self popToHomeVCWithAnimated:YES];
    }
}

- (void)actionShowMenu {
    _coverView.hidden = NO;
    _menuView.hidden = NO;
}

#pragma mark - Menu View Delegate

- (void)actionHideMenu {
    
    [self hideMenu:nil];
}

- (void)actionUpdateProfile {
    
    [self actionHideMenu];
    
    if (![self isKindOfClass:[EditProfileVC class]]) {
        
        if ([self isKindOfClass:[HomeVC class]]) {
            
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"] animated:YES];
        } else {
            
            ((NavigationController *)self.navigationController).strViewControllerName = @"EditProfileVC";
            
            [self popToHomeVCWithAnimated:NO];
        }
    }
}

- (void)actionManagePhoto {
    
    [self actionHideMenu];
    
    if (![self isKindOfClass:[ManagePhotoVC class]]) {
        
        if ([self isKindOfClass:[HomeVC class]]) {
            
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ManagePhotoVC"] animated:YES];
        } else {
            
            ((NavigationController *)self.navigationController).strViewControllerName = @"ManagePhotoVC";
            
            [self popToHomeVCWithAnimated:NO];
        }
    }
}

- (void)actionPendingReservation {
    
    [self actionHideMenu];
    
    if (![self isKindOfClass:[BookingListVC class]] || ((BookingListVC *)self).bookingCat != PENDING) {
        
        if ([self isKindOfClass:[HomeVC class]]) {
            
            BookingListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingListVC"];
            vc.bookingCat = PENDING;

            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            ((NavigationController *)self.navigationController).strViewControllerName = @"BookingListVC";
            ((NavigationController *)self.navigationController).bookingCat = PENDING;
            
            [self popToHomeVCWithAnimated:NO];
        }
    }
}

- (void)actionCurrentReservation {
    
    [self actionHideMenu];
    
    if (![self isKindOfClass:[BookingListVC class]] || ((BookingListVC *)self).bookingCat != CURRENT) {
        
        if ([self isKindOfClass:[HomeVC class]]) {
            
            BookingListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingListVC"];
            vc.bookingCat = CURRENT;
            vc.delegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            ((NavigationController *)self.navigationController).strViewControllerName = @"BookingListVC";
            ((NavigationController *)self.navigationController).bookingCat = CURRENT;
            
            [self popToHomeVCWithAnimated:NO];
        }
    }
}

- (void)actionPastReservation{
    [self actionHideMenu];
    
    if (![self isKindOfClass:[BookingListVC class]] || ((BookingListVC *)self).bookingCat != PAST) {
        
        if ([self isKindOfClass:[HomeVC class]]) {
            
            BookingListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingListVC"];
            vc.bookingCat = PAST;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            ((NavigationController *)self.navigationController).strViewControllerName = @"BookingListVC";
            ((NavigationController *)self.navigationController).bookingCat = PAST;
            
            [self popToHomeVCWithAnimated:NO];
        }
    }
}

- (void)actionCancelReservation{
    [self actionHideMenu];
    
    if (![self isKindOfClass:[BookingListVC class]] || ((BookingListVC *)self).bookingCat != CANCEL) {
        
        if ([self isKindOfClass:[HomeVC class]]) {
            
            BookingListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingListVC"];
            vc.bookingCat = CANCEL;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            ((NavigationController *)self.navigationController).strViewControllerName = @"BookingListVC";
            ((NavigationController *)self.navigationController).bookingCat = CANCEL;
            
            [self popToHomeVCWithAnimated:NO];
        }
    }
}

- (void)actionCompleteReservation {
    [self actionHideMenu];
    if (![self isKindOfClass:[BookingListVC class]] || ((BookingListVC *)self).bookingCat != PREVIOUS) {
        if ([self isKindOfClass:[HomeVC class]]) {
            BookingListVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BookingListVC"];
            vc.bookingCat = PREVIOUS;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            ((NavigationController *)self.navigationController).strViewControllerName = @"BookingListVC";
            ((NavigationController *)self.navigationController).bookingCat = PREVIOUS;
            [self popToHomeVCWithAnimated:NO];
        }
    }
}

- (void)actionLogout
{
    [self actionHideMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationStopMonitoringSigLocationChanges object:nil];
    [[WebServiceClient sharedClient] updateDeviceTokenToToken:@"" success:nil failure:nil];
    [AccountManager sharedManager].loggedIn = NO;
    // update location information from app delegate
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.curLocation = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Miscellaneous Functions

- (void)popToHomeVCWithAnimated:(BOOL)animated {
    
    UIViewController *vc;
    if ([self.navigationController.viewControllers[1] isKindOfClass:[HomeVC class]])
        vc = self.navigationController.viewControllers[1];
    else
        vc = self.navigationController.viewControllers[2];
    [self.navigationController popToViewController:vc animated:animated];
}

@end
