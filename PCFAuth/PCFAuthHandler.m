//
//  PCFAuthHandler.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-09.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import "PCFAuthHandler.h"
#import "PCFAuthLogger.h"
#import "PCFAFOAuth2Manager.h"
#import "PCFAuthUtil.h"
#import "PCFAuthConfig.h"
#import "PCFToken.h"

@interface PCFAuthHandler ()

@property BOOL disableUserPrompt;

@end

@implementation PCFAuthHandler

static NSString *PCFAuthIdentifierPrefix = @"PCFAuth:";

- (PCFAuthResponse *)fetchToken {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block PCFAuthResponse *result;
    
    [self fetchTokenWithCompletionBlock:^(PCFAuthResponse *response) {
        result = response;
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return result;
}

- (void)fetchTokenWithCompletionBlock:(PCFAuthResponseBlock)block {
    
    LogDebug(@"Checking for existing credentials.");
    
    PCFAFOAuthCredential *credential = [self retrieveCredential];
    
    if ([PCFToken isValid:credential.accessToken]) {
        if (block) {
            block([[PCFAuthResponse alloc] initWithAccessToken:credential.accessToken error:nil]);
        }
        
    } else if (credential.refreshToken) {
        [self refreshTokenWithCredential:credential completionBlock:block];
        
    } else if (!self.disableUserPrompt) {
        [self showLoginControllerWithBlock:block];
        
    } else if (block) {
        NSError *error = [NSError errorWithDomain:@"UnknownError" code:-1 userInfo:nil];
        block([[PCFAuthResponse alloc] initWithAccessToken:nil error:error]);
    }
}

- (void)refreshTokenWithCredential:(PCFAFOAuthCredential *)credential completionBlock:(PCFAuthResponseBlock)block {
    
    LogDebug(@"Exchanging refresh token.");
    
    [PCFAuthClient grantWithRefreshToken:credential.refreshToken completionBlock:^(PCFAFOAuthCredential *credential, NSError *error) {
        
        if (!error) {
            [self storeCredential:credential];
        } else {
            LogDebug(@"Received error.code: %d", error.code);
            
            if (error.code == 401 && !self.disableUserPrompt) {
                [self showLoginControllerWithBlock:block];
                return;
            }
        }
        
        if (block) {
            block([[PCFAuthResponse alloc] initWithAccessToken:credential.accessToken error:error]);
        }
    }];
}

- (void)showLoginControllerWithBlock:(PCFAuthResponseBlock)block {
    
    LogDebug(@"Launching login controller.");
    
    UIViewController *controller = [self createLoginViewControllerWithBlock:block];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
        [delegate.window.rootViewController presentViewController:controller animated:true completion:nil];
    });
}

- (UIViewController *)createLoginViewControllerWithBlock:(PCFAuthResponseBlock)block {
    PCFLoginViewController *viewController = [PCFAuthUtil findLoginViewController];
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    viewController.responseBlock = ^(PCFAFOAuthCredential *credential, NSError *error) {
        
        if (credential.accessToken) {
            [self storeCredential:credential];
            
        } else if (!error) {
            error = [NSError errorWithDomain:@"UnknownError" code:-1 userInfo:nil];
        }
        
        if (block) {
            block([[PCFAuthResponse alloc] initWithAccessToken:credential.accessToken error:error]);
        }
    };
    return viewController;
}

- (void)invalidateToken {
    
    LogDebug(@"Deleting existing credentials.");
    
    [self deleteCredential];
    
    NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *authCookies = [cookies cookiesForURL:[NSURL URLWithString:[PCFAuthConfig authorizeUrl]]];
    
    for (NSHTTPCookie* cookie in authCookies) {
        [cookies deleteCookie:cookie];
    }
}

- (void)disableUserPrompt:(BOOL)disable {
    self.disableUserPrompt = disable;
}

- (PCFAFOAuthCredential *)retrieveCredential {
    NSString *identifier = [PCFAuthIdentifierPrefix stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
    return [PCFAFOAuthCredential retrieveCredentialWithIdentifier:identifier];
}

- (void)storeCredential:(PCFAFOAuthCredential *)credential {
    NSString *identifier = [PCFAuthIdentifierPrefix stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
    [PCFAFOAuthCredential storeCredential:credential withIdentifier:identifier];
}

- (void)deleteCredential {
    NSString *identifier = [PCFAuthIdentifierPrefix stringByAppendingString:[[NSBundle mainBundle] bundleIdentifier]];
    [PCFAFOAuthCredential deleteCredentialWithIdentifier:identifier];
}

@end
