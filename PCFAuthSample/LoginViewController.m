//
//  LoginViewController.m
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-22.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "LoginViewController.h"
#import "PCFAFOAuth2Manager.h"

@implementation LoginViewController

- (instancetype)init {
    return [super initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *identifier = [@"PCFAuth:" stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
    PCFAFOAuthCredential *credential = [PCFAFOAuthCredential retrieveCredentialWithIdentifier:identifier];
    
    if (credential.refreshToken) {
        [self grantWithRefreshToken:credential.refreshToken];
    }
}

@end
