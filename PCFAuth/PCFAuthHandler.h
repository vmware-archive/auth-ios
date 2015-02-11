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

- (PCFAuthResponse *)fetchTokenWithUserPrompt:(BOOL)prompt;

- (void)fetchTokenWithUserPrompt:(BOOL)prompt completionBlock:(PCFAuthResponseBlock)block;

- (void)invalidateToken;

@end
