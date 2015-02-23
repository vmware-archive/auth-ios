//
//  PCFLoginViewController.h
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-22.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFAuthClient.h"

@class PCFAuthResponse;

@interface PCFLoginViewController : UIViewController

@property IBOutlet UITextField *usernameField;

@property IBOutlet UITextField *passwordField;

@property (strong) PCFAuthClientBlock responseBlock;

- (void)didReceiveLoginError:(NSError *)error;

- (IBAction)grantTypePassword:(id)sender;

- (IBAction)grantTypeAuthCode:(id)sender;

- (IBAction)cancel:(id)sender;

- (UIWebView *)webview;
- (NSString *)username;
- (NSString *)password;

@end
