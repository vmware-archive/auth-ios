//
//  PCFAuthCodeHandlerTests.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-11.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PCFAuthCodeHandler.h"
#import "PCFAuthConfig.h"

@interface PCFAuthCodeHandler ()

@property UIWebView *webView;
@property (strong) PCFAuthCodeBlock completionBlock;

- (NSString *)OAuthCodeFromRedirectURL:(NSURL *)redirectURL;

@end

@interface PCFAuthCodeHandlerTests : XCTestCase

@property NSString *code;
@property NSString *host;
@property NSString *scheme;

@end

@implementation PCFAuthCodeHandlerTests

- (void)setUp {
    [super setUp];
    
    self.code = [NSUUID UUID].UUIDString;
    self.host = [NSUUID UUID].UUIDString;
    self.scheme = [NSUUID UUID].UUIDString;
}

- (void)testInitializeWithWebview {
    UIWebView *webview = OCMClassMock([UIWebView class]);

    PCFAuthCodeHandler *handler = [[PCFAuthCodeHandler alloc] initWithWebView:webview];
    
    XCTAssertEqual(webview, handler.webView);
}

- (void)testLoad {
    UIWebView *webview = OCMClassMock([UIWebView class]);
    NSURLRequest *request = OCMClassMock([NSURLRequest class]);
    PCFAuthCodeBlock block = ^(NSString *code) {};
    PCFAuthCodeHandler *handler = [[PCFAuthCodeHandler alloc] initWithWebView:webview];
    
    [handler load:request completionHandler:block];
    
    XCTAssertEqual(block, handler.completionBlock);
    
    OCMVerify([webview setDelegate:handler]);
    OCMVerify([webview loadRequest:request]);
}

- (void)testWebViewShouldStartLoadingRequestWithRedirectURL {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    NSURLRequest *request = OCMClassMock([NSURLRequest class]);
    UIWebView *webView = OCMClassMock([UIWebView class]);
    webView.delegate = OCMProtocolMock(@protocol(UIWebViewDelegate));
    NSString *redirectUrlString = [NSString stringWithFormat:@"%@://%@", self.scheme, self.host];
    NSURL *requestUrl = [NSURL URLWithString:redirectUrlString];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    PCFAuthCodeHandler *handler = OCMPartialMock([[PCFAuthCodeHandler alloc] init]);
    handler.completionBlock = ^(NSString *c) {
        XCTAssertEqual(self.code, c);
        [expectation fulfill];
    };
    
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig redirectUrl]).andReturn(redirectUrlString);
    OCMStub([request URL]).andReturn(requestUrl);
    OCMStub([handler OAuthCodeFromRedirectURL:[OCMArg any]]).andReturn(self.code);
    
    XCTAssertEqual(NO, [handler webView:webView shouldStartLoadWithRequest:request navigationType:0]);
    XCTAssertNil(webView.delegate);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OCMVerify([handler OAuthCodeFromRedirectURL:requestUrl]);
    
    [pcfAuthConfig stopMocking];
}

- (void)testWebViewShouldStartLoadingRequestWithNonRedirectURL {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    NSURLRequest *request = OCMClassMock([NSURLRequest class]);
    NSString *redirectUrlString = [NSString stringWithFormat:@"%@://%@", self.scheme, self.host];
    NSString *requestUrlString = [NSString stringWithFormat:@"%@://%@", self.scheme, [NSUUID UUID].UUIDString];
    NSURL *requestUrl = [NSURL URLWithString:requestUrlString];
    PCFAuthCodeHandler *handler = [[PCFAuthCodeHandler alloc] init];
    
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig redirectUrl]).andReturn(redirectUrlString);
    OCMStub([request URL]).andReturn(requestUrl);
    
    XCTAssertEqual(YES, [handler webView:nil shouldStartLoadWithRequest:request navigationType:0]);
    
    [pcfAuthConfig stopMocking];
}

- (void)testOAuthCodeFromRedirectURLWithoutParams {
    NSURL *redirectUrl = OCMClassMock([NSURL class]);
    NSString *queryString = OCMClassMock([NSString class]);
    PCFAuthCodeHandler *handler = [[PCFAuthCodeHandler alloc] init];
    
    NSArray *params = @[];
    
    OCMStub([redirectUrl query]).andReturn(queryString);
    OCMStub([queryString componentsSeparatedByString:[OCMArg any]]).andReturn(params);
    
    XCTAssertNil([handler OAuthCodeFromRedirectURL:redirectUrl]);
    
    OCMVerify([queryString componentsSeparatedByString:@"&"]);
}

- (void)testOAuthCodeFromRedirectURLWithParams {
    NSURL *redirectUrl = OCMClassMock([NSURL class]);
    NSString *queryString = OCMClassMock([NSString class]);
    PCFAuthCodeHandler *handler = [[PCFAuthCodeHandler alloc] init];
    
    NSArray *params = @[ [NSString stringWithFormat:@"code=%@", self.code] ];
    
    OCMStub([redirectUrl query]).andReturn(queryString);
    OCMStub([queryString componentsSeparatedByString:[OCMArg any]]).andReturn(params);
    
    XCTAssertEqualObjects(self.code, [handler OAuthCodeFromRedirectURL:redirectUrl]);
    
    OCMVerify([queryString componentsSeparatedByString:@"&"]);
}

@end
