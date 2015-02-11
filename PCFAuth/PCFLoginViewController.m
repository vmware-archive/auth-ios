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
#import "PCFAuthResponse.h"
#import "PCFAuthCodeHandler.h"
#import "PCFAuthConfig.h"
#import "PCFAuth.h"

@interface PCFLoginViewController () {
    UIWebView *_webview;
}

@property IBOutlet UITextField *usernameField;
@property IBOutlet UITextField *passwordField;

@end

@implementation PCFLoginViewController


- (IBAction)grantTypePassword:(id)sender {
    [PCFAuthClient grantWithUsername:self.username password:self.password completionBlock:^(PCFAFOAuthCredential *credential, NSError *error) {
        [self handleResponse:credential error:error];
    }];
}

- (IBAction)grantTypeAuthCode:(id)sender {
    [PCFAuthClient grantWithAuthCodeFlow:self.webview completionBlock:^(PCFAFOAuthCredential *credential, NSError *error) {
        [self handleResponse:credential error:error];
    }];
}

- (void)didReceiveLoginError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:error.domain message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)handleResponse:(PCFAFOAuthCredential *)credential error:(NSError *)error {
    
    if (error) {
        [self didReceiveLoginError:error];
        return;
    }
    
    [self dismissViewControllerAnimated:true completion:^() {
        if (self.responseBlock) {
            self.responseBlock(credential, nil);
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:^() {
        if (self.responseBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"OperationCancelled" code:100 userInfo:nil];
            self.responseBlock(nil, error);
        }
    }];
}

- (UIWebView *)webview {
    if (!_webview) {
        _webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_webview];
    }
    return _webview;
}

- (NSString *)username {
    return self.usernameField.text;
}

- (NSString *)password {
    return self.passwordField.text;
}



@end
