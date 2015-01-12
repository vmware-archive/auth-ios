//
//  PCFLoginViewController.h
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-22.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFAuth.h"

@class PCFAFOAuthCredential;

@interface PCFLoginViewController : UIViewController<UIWebViewDelegate>

@property (strong) void (^successBlock)(PCFAFOAuthCredential*);
@property (strong) void (^failureBlock)(NSError*);

- (void)grantWithRefreshToken:(NSString *)refreshToken;
- (void)grantWithUsername:(NSString *)username password:(NSString *)password;
- (void)grantWithAuthCode:(NSString *)code;
- (void)grantWithAuthCodeFlow;

- (NSString *)username;
- (NSString *)password;

@end
