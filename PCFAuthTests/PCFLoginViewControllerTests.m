//
//  PCFLoginViewControllerTests.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-11.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PCFLoginViewController.h"
#import "PCFAFOAuth2Manager.h"

@interface PCFLoginViewController ()

- (IBAction)grantTypePassword:(id)sender;

- (IBAction)grantTypeAuthCode:(id)sender;

- (void)handleResponse:(PCFAFOAuthCredential *)credential error:(NSError *)error;

- (IBAction)cancel:(id)sender;

@end

@interface PCFLoginViewControllerTests : XCTestCase

@end

@implementation PCFLoginViewControllerTests

- (void)setUp {
    [super setUp];
}

- (void)testGrantTypePassword {
    id pcfAuthClient = OCMClassMock([PCFAuthClient class]);
    PCFAFOAuthCredential *credential = OCMClassMock([PCFAFOAuthCredential class]);
    PCFLoginViewController *controller = OCMPartialMock([[PCFLoginViewController alloc] init]);
    NSError *error = OCMClassMock([NSError class]);
    
    NSString *username = [NSUUID UUID].UUIDString;
    NSString *password = [NSUUID UUID].UUIDString;
    
    OCMStub([controller username]).andReturn(username);
    OCMStub([controller password]).andReturn(password);
    OCMStub([controller handleResponse:[OCMArg any] error:[OCMArg any]]).andDo(nil);
    OCMStub([pcfAuthClient grantWithUsername:[OCMArg any] password:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionBlock)(PCFAFOAuthCredential *, NSError *);
        [invocation getArgument:&completionBlock atIndex:4];
        completionBlock(credential, error);
    });
    
    [controller grantTypePassword:nil];

    OCMVerify([controller username]);
    OCMVerify([controller password]);
    OCMVerify([pcfAuthClient grantWithUsername:username password:password completionBlock:[OCMArg any]]);
    OCMVerify([controller handleResponse:credential error:error]);
    
    [pcfAuthClient stopMocking];
}

- (void)testGrantTypeAuthCode {
    id pcfAuthClient = OCMClassMock([PCFAuthClient class]);
    PCFAFOAuthCredential *credential = OCMClassMock([PCFAFOAuthCredential class]);
    PCFLoginViewController *controller = OCMPartialMock([[PCFLoginViewController alloc] init]);
    NSError *error = OCMClassMock([NSError class]);
    UIWebView *webview = OCMClassMock([UIWebView class]);
    
    OCMStub([controller webview]).andReturn(webview);
    OCMStub([controller handleResponse:[OCMArg any] error:[OCMArg any]]).andDo(nil);
    OCMStub([pcfAuthClient grantWithAuthCodeFlow:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionBlock)(PCFAFOAuthCredential *, NSError *);
        [invocation getArgument:&completionBlock atIndex:3];
        completionBlock(credential, error);
    });
    
    [controller grantTypeAuthCode:nil];
    
    OCMVerify([controller webview]);
    OCMVerify([pcfAuthClient grantWithAuthCodeFlow:webview completionBlock:[OCMArg any]]);
    OCMVerify([controller handleResponse:credential error:error]);
    
    [pcfAuthClient stopMocking];
}

- (void)testHandleResponseWithError {
    PCFLoginViewController *controller = OCMPartialMock([[PCFLoginViewController alloc] init]);
    NSError *error = OCMClassMock([NSError class]);
    
    OCMStub([controller didReceiveLoginError:[OCMArg any]]).andDo(nil);
    
    [controller handleResponse:nil error:error];
    
    OCMVerify([controller didReceiveLoginError:error]);
}

- (void)testHandleResponseWithoutError {
    PCFLoginViewController *controller = OCMPartialMock([[PCFLoginViewController alloc] init]);
    PCFAFOAuthCredential *credential = OCMClassMock([PCFAFOAuthCredential class]);
    
    OCMStub([controller dismissViewControllerAnimated:true completion:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionBlock)();
        [invocation getArgument:&completionBlock atIndex:3];
        completionBlock();
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];

    controller.responseBlock = ^(PCFAFOAuthCredential *c, NSError *error) {
        XCTAssertEqual(credential, c);
        XCTAssertNil(error);
        [expectation fulfill];
    };
    
    [controller handleResponse:credential error:nil];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

- (void)testCancel {
    PCFLoginViewController *controller = OCMPartialMock([[PCFLoginViewController alloc] init]);
    
    OCMStub([controller dismissViewControllerAnimated:true completion:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completionBlock)();
        [invocation getArgument:&completionBlock atIndex:3];
        completionBlock();
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];

    controller.responseBlock = ^(PCFAFOAuthCredential *credential, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNil(credential);
        [expectation fulfill];
    };
    
    [controller cancel:nil];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}

@end
