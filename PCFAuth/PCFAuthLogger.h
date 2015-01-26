//
//  PCFAuthLogger.h
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-10.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PCFAuth.h"

#define DEFAULT_LOGGER [PCFAuthLogger sharedInstance]

#define LogDebug(FMT, ...) \
    [DEFAULT_LOGGER logWithLevel:PCFAuthLogLevelDebug format:FMT, ##__VA_ARGS__]

#define LogInfo(FMT, ...) \
    [DEFAULT_LOGGER logWithLevel:PCFAuthLogLevelInfo format:FMT, ##__VA_ARGS__]

#define LogWarning(FMT, ...) \
    [DEFAULT_LOGGER logWithLevel:PCFAuthLogLevelWarning format:FMT, ##__VA_ARGS__]

#define LogError(FMT, ...) \
    [DEFAULT_LOGGER logWithLevel:PCFAuthLogLevelError format:FMT, ##__VA_ARGS__]

#define LogCritical(FMT, ...) \
    [DEFAULT_LOGGER logWithLevel:PCFAuthLogLevelCritical format:FMT, ##__VA_ARGS__]


@interface PCFAuthLogger : NSObject

@property PCFAuthLogLevel level;

+ (instancetype)sharedInstance;

- (void)logWithLevel:(PCFAuthLogLevel)level format:(NSString*)format, ...;

@end
