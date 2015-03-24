//
//  PCFAuth.m
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-17.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFAuth.h"
#import "PCFToken.h"
#import "PCFAFOAuth2Manager.h"
#import "PCFAuthClient.h"
#import "PCFAuthLogger.h"
#import "PCFAuthConfig.h"
#import "PCFAuthHandler.h"

@implementation PCFAuth

+ (void)logLevel:(PCFAuthLogLevel)level {
    [PCFAuthLogger sharedInstance].level = level;
}

+ (PCFAuthHandler *)handler {
    static PCFAuthHandler *handler = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        handler = [[PCFAuthHandler alloc] init];
    });
    return handler;
}

+ (void)registerLoginObserverBlock:(PCFLoginObserverBlock)block {
    [self.handler registerLoginObserverBlock:block];
}

+ (void)unregisterLoginObserverBlock {
    [self.handler registerLoginObserverBlock:nil];
}

+ (void)registerLogoutObserverBlock:(PCFLogoutObserverBlock)block {
    [self.handler registerLogoutObserverBlock:block];
}

+ (void)unregisterLogoutObserverBlock {
    [self.handler registerLogoutObserverBlock:nil];
}

+ (PCFAuthResponse *)fetchToken {
    return [self.handler fetchToken];
}

+ (void)fetchTokenWithCompletionBlock:(PCFAuthResponseBlock)block {
    [self.handler fetchTokenWithCompletionBlock:block];
}

+ (void)invalidateToken {
    [self.handler invalidateToken];
}

+ (void)logout {
    [self.handler logout];
}

+ (void)disableUserPrompt:(BOOL)disable {
    [self.handler disableUserPrompt:disable];
}

@end