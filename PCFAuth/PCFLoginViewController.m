//
//  PCFLoginViewController.m
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-22.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFLoginViewController.h"
#import "PCFAFURLRequestSerialization.h"
#import "PCFAFOAuth2Manager.h"
#import <PCFAuth/PCFAuthConfig.h>

@interface PCFLoginViewController ()
@property IBOutlet UITextField *usernameField;
@property IBOutlet UITextField *passwordField;
@end

@implementation PCFLoginViewController


- (IBAction)submit:(id)sender {
    [self grantWithUsername:[self username] password:[self password]];
}

- (NSString *)username {
    return self.usernameField.text;
}

- (NSString *)password {
    return self.passwordField.text;
}

- (void)grantWithRefreshToken:(NSString *)refreshToken {
    
    void (^successBlock)(PCFAFOAuthCredential*) = ^(PCFAFOAuthCredential *credential) {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.successBlock(credential);
    };
    
    void (^failBlock)(NSError*) = ^(NSError *error) {
        self.failureBlock(error);
    };
    
    NSURL *tokenUrl = [NSURL URLWithString:[PCFAuthConfig tokenUrl]];
    NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", [tokenUrl scheme], [tokenUrl host]]];
    NSString *path = [[[tokenUrl pathComponents] componentsJoinedByString:@"/"] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    
    PCFAFOAuth2Manager *manager = [PCFAFOAuth2Manager clientWithBaseURL:baseUrl clientID:[PCFAuthConfig clientId] secret:[PCFAuthConfig clientSecret]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[PCFAuthConfig clientId] password:[PCFAuthConfig clientSecret]];
    [manager authenticateUsingOAuthWithURLString:path refreshToken:refreshToken success:successBlock failure:failBlock];
}

- (void)grantWithUsername:(NSString *)username password:(NSString *)password {

    void (^successBlock)(PCFAFOAuthCredential*) = ^(PCFAFOAuthCredential *credential) {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.successBlock(credential);
    };

    void (^failBlock)(NSError*) = ^(NSError *error) {
        self.failureBlock(error);
    };

    NSURL *tokenUrl = [NSURL URLWithString:[PCFAuthConfig tokenUrl]];
    NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", [tokenUrl scheme], [tokenUrl host]]];
    NSString *path = [[[tokenUrl pathComponents] componentsJoinedByString:@"/"] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    
    PCFAFOAuth2Manager *manager = [PCFAFOAuth2Manager clientWithBaseURL:baseUrl clientID:[PCFAuthConfig clientId] secret:[PCFAuthConfig clientSecret]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[PCFAuthConfig clientId] password:[PCFAuthConfig clientSecret]];
    [manager authenticateUsingOAuthWithURLString:path username:username password:password scope:@"openid+offline_access" success:successBlock failure:failBlock];
}

- (void)grantWithAuthCode:(NSString *)code {
    
    void (^successBlock)(PCFAFOAuthCredential*) = ^(PCFAFOAuthCredential *credential) {
        [self dismissViewControllerAnimated:YES completion:nil];
        self.successBlock(credential);
    };
    
    void (^failBlock)(NSError*) = ^(NSError *error) {
        self.failureBlock(error);
    };
    
    NSURL *tokenUrl = [NSURL URLWithString:[PCFAuthConfig tokenUrl]];
    NSURL *baseUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", [tokenUrl scheme], [tokenUrl host]]];
    NSString *path = [[[tokenUrl pathComponents] componentsJoinedByString:@"/"] stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    
    PCFAFOAuth2Manager *manager = [PCFAFOAuth2Manager clientWithBaseURL:baseUrl clientID:[PCFAuthConfig clientId] secret:[PCFAuthConfig clientSecret]];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[PCFAuthConfig clientId] password:[PCFAuthConfig clientSecret]];
    [manager authenticateUsingOAuthWithURLString:path code:code redirectURI:[PCFAuthConfig redirectUrl] success:successBlock failure:failBlock];
}

- (void)grantWithAuthCodeFlow {
    
    NSDictionary *parameters = @{
         @"state" : [NSUUID UUID].UUIDString,
         @"redirect_uri" : [PCFAuthConfig redirectUrl],
         @"client_id" : [PCFAuthConfig clientId],
         @"approval_prompt" : @"force",
         @"response_type" : @"code",
         @"scope" : @"openid+offline_access",
     };
    
    NSString *encodedParams = PCFAFQueryStringFromParametersWithEncoding(parameters, NSUTF8StringEncoding);
    NSURL *urlWithParams = [NSURL URLWithString:[[PCFAuthConfig authorizeUrl] stringByAppendingFormat:@"?%@", encodedParams]];
    
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webview.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlWithParams];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.absoluteString.lowercaseString hasPrefix:[PCFAuthConfig redirectUrl].lowercaseString]) {
        NSString *code = [self oauthCodeFromRedirectURL:request.URL];
        [self grantWithAuthCode:code];
        return NO;
    }
    return YES;
}

- (NSString *)oauthCodeFromRedirectURL:(NSURL *)redirectURL {
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
