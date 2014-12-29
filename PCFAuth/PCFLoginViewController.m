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

@interface PCFLoginViewController ()
@property IBOutlet UITextField *usernameField;
@property IBOutlet UITextField *passwordField;
@end

@implementation PCFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *identifier = [@"PCFAuth:" stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
//    PCFAFOAuthCredential *credential = [PCFAFOAuthCredential retrieveCredentialWithIdentifier:identifier];
//
//    [self refreshTokenGrantWithToken:credential.refreshToken];
}

- (IBAction)submit:(id)sender {
    [self grantWithUsername:[self username] password:[self password]];
}

- (NSString *)username {
    return self.usernameField.text;
}

- (NSString *)password {
    return self.passwordField.text;
}

- (void)grantWithUsername:(NSString *)username password:(NSString *)password {

    void (^successBlock)(PCFAFOAuthCredential*) = ^(PCFAFOAuthCredential *credential) {
        NSString *identifier = [@"PCFAuth:" stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
        [PCFAFOAuthCredential storeCredential:credential withIdentifier:identifier];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };

    void (^failBlock)(NSError*) = ^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };

    NSURL *baseUrl = [NSURL URLWithString:@"http://uaa.kona.coffee.cfms-apps.com"];
    
    NSString *clientId = @"ios-client";
    NSString *clientSecret = @"006d0cea91f01a82cdc57afafbbc0d26c8328964029d5b5eae920e2fdc703169";
    NSString *tokenUrl = @"/oauth/token";
    
    NSString *scope = @"openid,offline_access";
    
    PCFAFOAuth2Manager *manager = [PCFAFOAuth2Manager clientWithBaseURL:baseUrl clientID:clientId secret:clientSecret];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:clientId password:clientSecret];
    [manager authenticateUsingOAuthWithURLString:tokenUrl username:username password:password scope:scope success:successBlock failure:failBlock];
}

- (void)grantWithRefreshToken:(NSString *)refreshToken {
    
    void (^successBlock)(PCFAFOAuthCredential*) = ^(PCFAFOAuthCredential *credential) {
        NSString *identifier = [@"PCFAuth:" stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
        [PCFAFOAuthCredential storeCredential:credential withIdentifier:identifier];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    void (^failBlock)(NSError*) = ^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };

    NSURL *baseUrl = [NSURL URLWithString:@"http://uaa.kona.coffee.cfms-apps.com"];
    
    NSString *clientId = @"ios-client";
    NSString *clientSecret = @"006d0cea91f01a82cdc57afafbbc0d26c8328964029d5b5eae920e2fdc703169";
    NSString *tokenUrl = @"/oauth/token";
    
    PCFAFOAuth2Manager *manager = [PCFAFOAuth2Manager clientWithBaseURL:baseUrl clientID:clientId secret:clientSecret];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:clientId password:clientSecret];
    [manager authenticateUsingOAuthWithURLString:tokenUrl refreshToken:refreshToken success:successBlock failure:failBlock];
}


- (void)grantWithAuthCodeFlow {
    NSURL *baseUrl = [NSURL URLWithString:@"http://uaa.kona.coffee.cfms-apps.com"];
    
    NSString *clientId = @"ios-client";
    NSString *authorizeUrl = @"/oauth/authorize";
    
    NSString *redirectUrl = @"io.pivotal.ios.PCFAuthSample://oauth2callback";
    
    NSDictionary *parameters = @{
         //         @"state" : @"/profile",
         @"redirect_uri" : redirectUrl,
         @"response_type" : @"code",
         @"client_id" : clientId,
         @"approval_prompt" : @"force",
         @"scope" : @"openid offline_access", // TODO - find out why offline_access isn't being granted
     };
    
    NSString *encodedParams = PCFAFQueryStringFromParametersWithEncoding(parameters, NSUTF8StringEncoding);
    NSURL *urlWithParams = [NSURL URLWithString:[[baseUrl absoluteString] stringByAppendingFormat:@"%@?%@", authorizeUrl, encodedParams]];
    
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webview.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:urlWithParams];
    [webview loadRequest:request];
    
    [self.view addSubview:webview];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *redirectUrl = @"io.pivotal.ios.PCFAuthSample://oauth2callback";
    
    if ([request.URL.absoluteString.lowercaseString hasPrefix:redirectUrl.lowercaseString]) {
        NSString *code = [self oauthCodeFromRedirectURI:request.URL];
        [self grantWithAuthCode:code];
        return NO;
    }
    return YES;
}

- (NSString *)oauthCodeFromRedirectURI:(NSURL *)redirectURI {
    __block NSString *code;
    NSArray *pairs = [redirectURI.query componentsSeparatedByString:@"&"];
    [pairs enumerateObjectsUsingBlock:^(NSString *pair, NSUInteger idx, BOOL *stop) {
        if ([pair hasPrefix:@"code"]) {
            code = [pair substringFromIndex:5];
            *stop = YES;
        }
    }];
    return code;
}

- (void)grantWithAuthCode:(NSString *)code {
    
    void (^successBlock)(PCFAFOAuthCredential*) = ^(PCFAFOAuthCredential *credential) {
        NSString *identifier = [@"PCFAuth:" stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
        [PCFAFOAuthCredential storeCredential:credential withIdentifier:identifier];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    void (^failBlock)(NSError*) = ^(NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    NSURL *baseUrl = [NSURL URLWithString:@"http://uaa.kona.coffee.cfms-apps.com"];
    
    NSString *clientId = @"ios-client";
    NSString *clientSecret = @"006d0cea91f01a82cdc57afafbbc0d26c8328964029d5b5eae920e2fdc703169";
    NSString *tokenUrl = @"/oauth/token";
    
    NSString *redirectUrl = @"io.pivotal.ios.PCFAuthSample://oauth2callback";
    
    PCFAFOAuth2Manager *manager = [PCFAFOAuth2Manager clientWithBaseURL:baseUrl clientID:clientId secret:clientSecret];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:clientId password:clientSecret];
    [manager authenticateUsingOAuthWithURLString:tokenUrl code:code redirectURI:redirectUrl success:successBlock failure:failBlock];
}


@end
