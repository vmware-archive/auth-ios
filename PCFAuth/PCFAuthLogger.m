//
//  PCFAuthLogger.m
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-10.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFAuthLogger.h"

@implementation PCFAuthLogger

+ (instancetype)sharedInstance {
    static PCFAuthLogger *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PCFAuthLogger alloc] init];
        sharedInstance.level = PCFAuthLogLevelWarning;
    });
    return sharedInstance;
}

- (void)logWithLevel:(PCFAuthLogLevel)level format:(NSString*)format, ... NS_FORMAT_FUNCTION(2,3) {

    va_list args;
    va_start(args, format);

    if (level >= self.level) {
        NSLogv(format, args);
    }
    
    va_end(args);
}

@end
