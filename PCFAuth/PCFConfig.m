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

static NSString* const PCFTokenUrl = @"pivotal.data.tokenUrl";


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

- (NSString *)tokenUrl {
    return [self.values objectForKey:PCFTokenUrl];
}

- (NSDictionary *)values {
    if (!_values) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Pivotal" ofType:@"plist"];
        _values = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return _values;
}

@end
