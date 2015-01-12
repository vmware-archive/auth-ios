//
//  PCFConfig.m
//  PCFData
//
//  Created by DX122-XL on 2014-12-08.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFConfig.h"

@interface PCFConfig () {
    NSDictionary *_values;
}

@property (readonly) NSDictionary *values;

@end


@implementation PCFConfig

static NSString* const PCFConfiguration = @"PCFConfiguration";
static NSString* const PCFPropertyMissing = @"Property missing from Pivotal.plist: ";

static NSString* const PCFTokenUrl = @"pivotal.auth.tokenUrl";
static NSString* const PCFAuthorizeUrl = @"pivotal.auth.authorizeUrl";
static NSString* const PCFRedirectUrl = @"pivotal.auth.redirectUrl";
static NSString* const PCFClientId = @"pivotal.auth.clientId";
static NSString* const PCFClientSecret = @"pivotal.auth.clientSecret";


+ (PCFConfig *)sharedInstance {
    static PCFConfig *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PCFConfig alloc] init];
    });
    return sharedInstance;
}

+ (NSString *)tokenUrl {
    return [[PCFConfig sharedInstance] tokenUrl];
}

+ (NSString *)authorizeUrl {
    return [[PCFConfig sharedInstance] authorizeUrl];
}

+ (NSString *)redirectUrl {
    return [[PCFConfig sharedInstance] redirectUrl];
}

+ (NSString *)clientId {
    return [[PCFConfig sharedInstance] clientId];
}

+ (NSString *)clientSecret {
    return [[PCFConfig sharedInstance] clientSecret];
}

- (NSString *)tokenUrl {
    NSString *tokenUrl = [self.values objectForKey:PCFTokenUrl];
    if (!tokenUrl) {
        NSString *reason = [PCFPropertyMissing stringByAppendingString:PCFTokenUrl];
        @throw [NSException exceptionWithName:PCFConfiguration reason:reason userInfo:nil];
    }
    return tokenUrl;
}

- (NSString *)authorizeUrl {
    NSString *authorizeUrl = [self.values objectForKey:PCFAuthorizeUrl];
    if (!authorizeUrl) {
        NSString *reason = [PCFPropertyMissing stringByAppendingString:PCFAuthorizeUrl];
        @throw [NSException exceptionWithName:PCFConfiguration reason:reason userInfo:nil];
    }
    return authorizeUrl;
}

- (NSString *)redirectUrl {
    NSString *redirectUrl = [self.values objectForKey:PCFRedirectUrl];
    if (!redirectUrl) {
        NSString *reason = [PCFPropertyMissing stringByAppendingString:PCFRedirectUrl];
        @throw [NSException exceptionWithName:PCFConfiguration reason:reason userInfo:nil];
    }
    return redirectUrl;
}

- (NSString *)clientId {
    NSString *clientId = [self.values objectForKey:PCFClientId];
    if (!clientId) {
        NSString *reason = [PCFPropertyMissing stringByAppendingString:PCFClientId];
        @throw [NSException exceptionWithName:PCFConfiguration reason:reason userInfo:nil];
    }
    return clientId;
}

- (NSString *)clientSecret {
    NSString *clientSecret = [self.values objectForKey:PCFClientSecret];
    if (!clientSecret) {
        NSString *reason = [PCFPropertyMissing stringByAppendingString:PCFClientSecret];
        @throw [NSException exceptionWithName:PCFConfiguration reason:reason userInfo:nil];
    }
    return clientSecret;
}

- (NSDictionary *)values {
    if (!_values) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Pivotal" ofType:@"plist"];
        _values = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _values;
}

@end
