//
//  PCFAuthCodeHandler.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-05.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import "PCFAuthCodeHandler.h"
#import "PCFAuthConfig.h"
#import "PCFAuth.h"

@interface PCFAuthCodeHandler ()

@property UIWebView *webView;

@property (strong) PCFAuthCodeBlock completionBlock;

@end

@implementation PCFAuthCodeHandler

- (instancetype)initWithWebView:(UIWebView *)webview {
    self = [super init];
    _webView = webview;
    return self;
}

- (void)load:(NSURLRequest *)request completionHandler:(PCFAuthCodeBlock)block {
    self.completionBlock = block;
    
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString.lowercaseString hasPrefix:[PCFAuthConfig redirectUrl].lowercaseString]) {
        
        webView.delegate = nil;
        
        if (self.completionBlock) {
            NSString *code = [self OAuthCodeFromRedirectURL:request.URL];
            self.completionBlock(code);
        }
        
        return NO;
    }
    return YES;
}

- (NSString *)OAuthCodeFromRedirectURL:(NSURL *)redirectURL {
    __block NSString *code;
    NSArray *pairs = [redirectURL.query componentsSeparatedByString:@"&"];
    [pairs enumerateObjectsUsingBlock:^(NSString *pair, NSUInteger idx, BOOL *stop) {
        if ([pair hasPrefix:@"code"]) {
            code = [pair substringFromIndex:5];
            *stop = YES;
        }
    }];
    return code;
}

@end
