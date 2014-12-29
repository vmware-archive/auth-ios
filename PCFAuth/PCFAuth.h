//
//  PCFAuth.h
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-17.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TokenBlock)(NSString *accessToken);

@interface PCFAuth : NSObject

+ (void)tokenWithBlock:(TokenBlock)block;

@end
