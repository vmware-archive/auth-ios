//
//  PCFAuthHandler.h
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-09.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCFAuth.h"

@class PCFAuthResponse;

@interface PCFAuthHandler : NSObject

- (void)registerLoginObserverBlock:(PCFLoginObserverBlock)block;

- (void)registerLogoutObserverBlock:(PCFLogoutObserverBlock)block;

- (PCFAuthResponse *)fetchToken;

- (void)fetchTokenWithCompletionBlock:(PCFAuthResponseBlock)block;

- (void)invalidateToken;

- (void)disableUserPrompt:(BOOL)disable;

@end
