//
//  PCFAuthResponse.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-05.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import "PCFAuthResponse.h"

@implementation PCFAuthResponse

- (instancetype)initWithAccessToken:(NSString *)accessToken error:(NSError *)error {
    self = [super init];
    _accessToken = accessToken;
    _error = error;
    return self;
}

@end
