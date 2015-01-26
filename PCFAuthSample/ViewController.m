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

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)authorize:(id)sender {
    [PCFAuth tokenWithBlock:^(NSString *accessToken, NSError *error) {
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:error.domain message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
        NSLog(@"Logged in.  Access code is %@.", accessToken);
    }];
}

@end
