//
//  AppDelegate.m
//  PCFAuthSample
//
//  Created by DX122-XL on 2014-12-19.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "AppDelegate.h"
#import <PCFAuth/PCFAuth.h>


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [PCFAuth logLevel:PCFAuthLogLevelDebug];
    
    return YES;
}


@end
