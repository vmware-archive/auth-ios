//
//  PCFLoginViewController.h
//  PCFAuth
//
//  Created by DX122-XL on 2014-12-22.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCFAuth.h"

@interface PCFLoginViewController : UIViewController<UIWebViewDelegate>

- (IBAction)submit:(id)sender;

- (NSString *)username;
- (NSString *)password;

@end
