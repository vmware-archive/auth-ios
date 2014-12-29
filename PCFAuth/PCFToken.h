//
//  PCFToken.h
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-23.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCFToken : NSObject

+ (BOOL)isValid:(NSString *)accessToken;

@end
