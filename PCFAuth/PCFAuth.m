//
//  PCFAuth.m
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-17.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "PCFAuth.h"
#import "PCFToken.h"
#import "PCFAFOAuth2Manager.h"
#import "PCFLoginViewController.h"
#import <objc/runtime.h>


@implementation PCFAuth

+ (void)tokenWithBlock:(TokenBlock)block {

    NSString *identifier = [@"PCFAuth:" stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
    PCFAFOAuthCredential *credential = [PCFAFOAuthCredential retrieveCredentialWithIdentifier:identifier];
    
    if ([PCFToken isValid:credential.accessToken]) {
        if (block) {
            block(credential.accessToken);
        }
        
    } else {
        PCFLoginViewController *viewController = [PCFAuth loginViewController];
        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentViewController:viewController animated:YES completion:^(void) {
            
            NSString *identifier = [@"PCFAuth:" stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
            PCFAFOAuthCredential *credential = [PCFAFOAuthCredential retrieveCredentialWithIdentifier:identifier];
            
            if (block) {
                block(credential.accessToken);
            }
        }];
    }
}

+ (PCFLoginViewController *)loginViewController {
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
    
    return [PCFAuth defaultClass];
}

+ (PCFLoginViewController *)defaultClass {
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"io.pivotal.ios.PCFAuth"];
    NSString *name = [NSString stringWithCString:class_getName([PCFLoginViewController class]) encoding:NSASCIIStringEncoding];
    return [[PCFLoginViewController alloc] initWithNibName:name bundle:bundle];
}
     
@end