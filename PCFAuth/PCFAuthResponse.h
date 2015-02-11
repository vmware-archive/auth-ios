//
//  PCFAuthResponse.h
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-05.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFAuthResponse : NSObject

@property NSString *accessToken;
@property NSError *error;

- (instancetype)initWithAccessToken:(NSString *)accessToken error:(NSError *)error;

@end
