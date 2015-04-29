//
//  PCFConfig.m
//  PCFData
//
//  Created by DX122-XL on 2014-12-08.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFAuthConfig.h"

@interface PCFAuthConfig () {
    NSDictionary *_values;
}

@property (readonly) NSDictionary *values;

@end


@implementation PCFAuthConfig

static NSString* const PCFConfiguration = @"PCFConfiguration";
static NSString* const PCFPropertyMissing = @"Property missing from Pivotal.plist: ";

static NSString* const PCFTokenUrl = @"pivotal.auth.tokenUrl";
static NSString* const PCFAuthorizeUrl = @"pivotal.auth.authorizeUrl";
static NSString* const PCFRedirectUrl = @"pivotal.auth.redirectUrl";
static NSString* const PCFClientId = @"pivotal.auth.clientId";
static NSString* const PCFClientSecret = @"pivotal.auth.clientSecret";
static NSString* const PCFScopes = @"pivotal.auth.scopes";


+ (PCFAuthConfig *)sharedInstance {
    static PCFAuthConfig *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PCFAuthConfig alloc] init];
    });
    return sharedInstance;
}

+ (NSString *)tokenUrl {
    return [[PCFAuthConfig sharedInstance] tokenUrl];
}

+ (NSString *)authorizeUrl {
    return [[PCFAuthConfig sharedInstance] authorizeUrl];
}

+ (NSString *)redirectUrl {
    return [[PCFAuthConfig sharedInstance] redirectUrl];
}

+ (NSString *)clientId {
    return [[PCFAuthConfig sharedInstance] clientId];
}

+ (NSString *)clientSecret {
    return [[PCFAuthConfig sharedInstance] clientSecret];
}

+ (NSString *)scopes {
    return [[PCFAuthConfig sharedInstance] scopes];
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

- (NSString *)scopes {
    NSString *scopes = [self.values objectForKey:PCFScopes];
    if (!scopes) {
        NSString *reason = [PCFPropertyMissing stringByAppendingString:PCFScopes];
        @throw [NSException exceptionWithName:PCFConfiguration reason:reason userInfo:nil];
    }
    return scopes;
}

- (NSDictionary *)values {
    if (!_values) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Pivotal" ofType:@"plist"];
        _values = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _values;
}

@end
