//
//  PCFAuthClient.h
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-05.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PCFAFOAuthCredential, PCFAuthCodeHandler;

typedef void(^PCFAuthClientBlock)(PCFAFOAuthCredential*, NSError*);

@interface PCFAuthClient : NSObject

+ (void)grantWithRefreshToken:(NSString *)refreshToken completionBlock:(PCFAuthClientBlock)block;

+ (void)grantWithUsername:(NSString *)username password:(NSString *)password completionBlock:(PCFAuthClientBlock)block;

+ (void)grantWithAuthCode:(NSString *)code completionBlock:(PCFAuthClientBlock)block;

+ (void)grantWithAuthCodeFlow:(UIWebView *)webview completionBlock:(PCFAuthClientBlock)block;

@end
