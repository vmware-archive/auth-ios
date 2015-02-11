//
//  PCFAuthUtil.h
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-05.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCFLoginViewController;

@interface PCFAuthUtil : NSObject

+ (PCFLoginViewController *)findLoginViewController;

@end
