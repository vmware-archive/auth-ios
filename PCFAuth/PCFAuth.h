//
//  PCFAuth.h
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-17.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PCFAuth/PCFLoginViewController.h>

typedef void(^TokenBlock)(NSString *accessToken, NSError *error);

typedef NS_ENUM(NSInteger, PCFAuthLogLevel) {
    PCFAuthLogLevelDebug = 0,
    PCFAuthLogLevelInfo,
    PCFAuthLogLevelWarning,
    PCFAuthLogLevelError,
    PCFAuthLogLevelCritical,
    PCFAuthLogLevelNone
};

@interface PCFAuth : NSObject

+ (void)tokenWithBlock:(TokenBlock)block;

+ (void)logLevel:(PCFAuthLogLevel)level;

@end
