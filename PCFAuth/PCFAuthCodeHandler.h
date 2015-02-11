//
//  PCFAuthCodeHandler.h
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-05.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PCFAuthCodeBlock)(NSString*);

@interface PCFAuthCodeHandler : NSObject<UIWebViewDelegate>

- (instancetype)initWithWebView:(UIWebView *)webview;

- (void)load:(NSURLRequest *)request completionHandler:(PCFAuthCodeBlock)block;

@end
