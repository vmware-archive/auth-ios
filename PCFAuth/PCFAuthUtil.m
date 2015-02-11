//
//  PCFAuthUtil.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-05.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import "PCFAuthUtil.h"
#import "PCFLoginViewController.h"
#import <objc/runtime.h>

@implementation PCFAuthUtil

+ (PCFLoginViewController *)findLoginViewController {
    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0) {
        classes = (__unsafe_unretained Class *) malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            
            Class thisClass = classes[i];
            Class superClass = thisClass;
            
            do {
                superClass = class_getSuperclass(superClass);
            } while(superClass && superClass != [PCFLoginViewController class]);
            
            if (superClass == nil) {
                continue;
            }
            
            PCFLoginViewController *instance = [[thisClass alloc] init];
            free(classes);
            return instance;
            
        }
        free(classes);
    }
    
    return [PCFAuthUtil defaultClass];
}

+ (PCFLoginViewController *)defaultClass {
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"io.pivotal.ios.PCFAuth"];
    NSString *name = [NSString stringWithCString:class_getName([PCFLoginViewController class]) encoding:NSASCIIStringEncoding];
    return [[PCFLoginViewController alloc] initWithNibName:name bundle:bundle];
}

@end
