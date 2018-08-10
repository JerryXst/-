//
//  WZOHWebViewController.m
//  ChatDemo-UI3.0
//
//  Created by JerryXst on 2018/8/8.
//  Copyright © 2018 JerryXst. All rights reserved.
//

#import "WZOHWebViewController.h"
#import <Hyphenate/EMClient.h>
#import "DemoCallManager.h"

@interface WZOHWebViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WZOHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self loadURL:[self testWebPath]];
}

- (NSURL *)testWebPath {
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"test" ofType:@"html"];
    return [NSURL fileURLWithPath:filePath];
}

- (void)loadURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)invokeJSBridge {
    NSString *filePath = [NSBundle.mainBundle pathForResource:@"callNative" ofType:@"js"];
    NSData *jsData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSString *str = [[NSString alloc] initWithData:jsData encoding:4];
    [self.webView stringByEvaluatingJavaScriptFromString:str];
}

- (UIWebView *)webView {
    if (nil == _webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!CGRectEqualToRect(_webView.frame, self.view.bounds)) {
        self.webView.frame = self.view.bounds;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    NSString *schema = request.URL.scheme;
    NSString *targetSchema = [webView stringByEvaluatingJavaScriptFromString:@"iOS.schema"];
    if ([schema.lowercaseString isEqualToString:targetSchema]) {
        EMCallType type = [request.URL.host.lowercaseString isEqualToString:@"callvideo"] ? EMCallTypeVideo : EMCallTypeVoice;
        // get peerID
        NSString *strURL = request.URL.absoluteString;
        NSString *indicator = @"peerID=";
        NSRange range = [strURL rangeOfString:indicator];
        if (NSNotFound == range.location) {
            NSLog(@"");
            return NO;
        }
        
        NSString *peerID = [strURL substringFromIndex:range.location+indicator.length];
        [[DemoCallManager sharedManager] makeCallWithUsername:peerID type:type isCustomVideoData:NO];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    return;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    [self invokeJSBridge];
}

@end
