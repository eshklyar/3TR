//
//  WebViewController.m
//  3TR
//
//  Created by Edik Shklyar on 4/18/15.
//  Copyright (c) 2015 Edik Shklyar. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled = TRUE;
    self.webView.scalesPageToFit = TRUE;


    NSString *urlString = [NSString new];
//    urlString = @"http://www.en.wikipedia.org/wiki/Tic-tac-toe";
    urlString = @"http://google.com";


    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url = %@",url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    NSLog(@"urlReq = %@",urlRequest);
    [self.webView loadRequest:urlRequest];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;


}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"view will Appear");

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    //    NSString *requestPath = [[urlRequest URL] absoluteString];
    //    self.urlTextField.text =requestPath;

    //    self.urlTextField.text = self.webView.request.description.uppercaseString;
    self.title = self.webView.request.URL.host;

    if (self.webView.scrollView.tracking) {

        NSLog(@"tracking");
    } else {
        NSLog(@" not tracking");
    }



}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}
- (IBAction)onReloadBtnPressed:(UIButton *)btn {

      [self.webView reload];
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
