//
//  PCFToken.m
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-23.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFToken.h"

@implementation PCFToken

+ (BOOL)isValid:(NSString *)accessToken {
    
    if (!accessToken) {
        return false;
    }
    
    NSArray *parts = [accessToken componentsSeparatedByString:@"."];
    if (parts.count > 1) {
        NSString *padded = [PCFToken addBase64Padding:parts[1]];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:padded options:0];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        int expirationTime = [[dict objectForKey:@"exp"] intValue];
        int currentTime = [[NSDate date] timeIntervalSince1970];
        int timeDifference = expirationTime - currentTime;
        NSLog(@"Token expires in %d minutes.", (timeDifference / 60));
        return timeDifference > 30;
    } else {
        return true;
    }
}

+ (NSString *)addBase64Padding:(NSString *)someString {
    long length = someString.length + (4 - (someString.length % 4));
    return [someString stringByPaddingToLength:length withString:@"=" startingAtIndex:0];
}

@end
