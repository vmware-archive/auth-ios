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

@property (strong) PCFAuthClientBlock responseBlock;

- (void)didReceiveLoginError:(NSError *)error;

- (UIWebView *)webview;
- (NSString *)username;
- (NSString *)password;

@end
