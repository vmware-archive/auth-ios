//
//  LoginViewController.m
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-22.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (instancetype)init {
    return [super initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
}

- (NSString *)username {
    return @"test";
}

- (NSString *)password {
    return @"password";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
