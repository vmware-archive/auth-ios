//
//  ViewController.m
//  PCFAuthSample
//
//  Created by DX122-XL on 2014-12-19.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "ViewController.h"
#import <PCFAuth/PCFAuth.h>

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)authorize:(id)sender {
    [PCFAuth fetchTokenWithCompletionBlock:^(PCFAuthResponse *response) {
        [self handleResponse:response];
    }];
}

- (void)handleResponse:(PCFAuthResponse *)response {
    if (response.error) {
        [[[UIAlertView alloc] initWithTitle:response.error.domain message:response.error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        NSLog(@"Logged in.  Access code is %@.", response.accessToken);
    }
}

- (IBAction)logout:(id)sender {
    [PCFAuth invalidateToken];
}

@end
