//
//  PCFToken.m
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-23.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFToken.h"
#import "PCFAuthLogger.h"

@implementation PCFToken

static int PCFExpirationWindow = 30;

+ (BOOL)isValid:(NSString *)accessToken {
    if (accessToken) {
        return [self parseToken:accessToken];
    } else {
        return false;
    }
}

+ (BOOL)parseToken:(NSString *)accessToken {
    NSArray *parts = [accessToken componentsSeparatedByString:@"."];
    if (parts.count > 1) {
        NSString *paddedToken = [self addBase64Padding:parts[1]];
        int expiresIn = [self calculateExpirationFromToken:paddedToken];
        LogDebug(@"Token expires in %d minutes.", (expiresIn / 60));
        return expiresIn > PCFExpirationWindow;
    } else {
        return true;
    }
}

+ (int)calculateExpirationFromToken:(NSString *)accessToken {
    @try {
        int expirationTime = [self decodeExpirationFromToken:accessToken];
        int currentTime = [[NSDate date] timeIntervalSince1970];
        return expirationTime - currentTime;
    }
    @catch (NSException *exception) {
        return PCFExpirationWindow + 1;
    }
}

+ (int)decodeExpirationFromToken:(NSString *)accessToken {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:accessToken options:0];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [[dict objectForKey:@"exp"] intValue];
}

+ (NSString *)addBase64Padding:(NSString *)someString {
    long length = someString.length + (4 - (someString.length % 4));
    return [someString stringByPaddingToLength:length withString:@"=" startingAtIndex:0];
}

@end
