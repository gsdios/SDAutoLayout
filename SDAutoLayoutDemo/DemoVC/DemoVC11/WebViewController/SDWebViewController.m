//
//  SDWebViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/16.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import "SDWebViewController.h"

@interface SDWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SDWebViewController

+ (instancetype)webViewControllerWithUrlString:(NSString *)urlString
{
    SDWebViewController *vc = [SDWebViewController new];
    vc.urlString = urlString;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [UIWebView new];
    self.webView.frame = self.view.bounds;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


@end
