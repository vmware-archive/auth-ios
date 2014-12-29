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
    [PCFAuth tokenWithBlock:^(NSString *accessToken) {
        
        NSLog(@"Logged in.  Access code is %@.", accessToken);
    }];
}

@end
