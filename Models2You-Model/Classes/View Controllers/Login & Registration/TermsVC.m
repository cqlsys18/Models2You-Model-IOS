//
//  TermsVC.m
//  Models2You
//
//  Created by user on 11/16/15.
//  Copyright © 2015 Valtus Real Estate, LLC. All rights reserved.
//

#import "TermsVC.h"

@interface TermsVC ()

- (IBAction)actionBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
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

- (void)loadData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Terms of Use" ofType:@"htm"];
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if (!error) {
    
        NSURL *baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [path substringToIndex:[path rangeOfString:@"Terms of Use.htm"].location]]];
        [_webView loadHTMLString:content baseURL:baseURL];
    }
}

#pragma mark - Action Delegate

- (IBAction)actionBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
