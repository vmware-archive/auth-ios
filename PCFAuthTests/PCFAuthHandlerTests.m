//
//  PCFAuthHandlerTests.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-09.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <PCFAuth/PCFAuth.h>
#import "PCFAuthHandler.h"
#import "PCFAuthUtil.h"
#import "PCFAFOAuth2Manager.h"
#import "PCFToken.h"
#import "PCFAuthConfig.h"

@interface PCFAuthUtil ()

+ (PCFLoginViewController *)findLoginViewController;

@end

@interface PCFAuthHandler ()

- (void)refreshTokenWithCredential:(PCFAFOAuthCredential *)credential completionBlock:(PCFAuthResponseBlock)block;

- (void)showLoginControllerWithBlock:(PCFAuthResponseBlock)block;

- (UIViewController *)createLoginViewControllerWithBlock:(PCFAuthResponseBlock)block;

- (PCFAFOAuthCredential *)retrieveCredential;

- (void)storeCredential:(PCFAFOAuthCredential *)credential;

- (void)deleteCredential;

@end

@interface PCFAuthHandlerTests : XCTestCase

@property NSString *refreshToken;
@property NSString *token;
@property NSString *tokenType;
@property NSInteger errorCode;
@property NSString *authUrl;
@property BOOL prompt;

@end

@implementation PCFAuthHandlerTests

- (void)setUp {
    [super setUp];
    
    self.refreshToken = [NSUUID UUID].UUIDString;
    self.token = [NSUUID UUID].UUIDString;
    self.tokenType = [NSUUID UUID].UUIDString;
    self.prompt = arc4random_uniform(2);
    self.errorCode = arc4random_uniform(1000) - 500;
    self.authUrl = [[NSString alloc] initWithFormat:@"http://%@.com", [NSUUID UUID].UUIDString];
}

- (void)testFetchTokenWithUserPrompt {
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    __block PCFAuthResponse *response = OCMClassMock([PCFAuthResponse class]);
    
    OCMStub([authHandler fetchTokenWithUserPrompt:self.prompt completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^block)(PCFAuthResponse*);
        [invocation getArgument:&block atIndex:3];
        block(response);
    });
    
    XCTAssertEqual(response, [authHandler fetchTokenWithUserPrompt:self.prompt]);
}

- (void)testFetchTokenCompletionBlockWithValidToken {
    id pcfToken = OCMClassMock([PCFToken class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFAFOAuthCredential *credential = [[PCFAFOAuthCredential alloc] initWithOAuthToken:self.token tokenType:self.tokenType];
    
    OCMStub([authHandler retrieveCredential]).andReturn(credential);
    OCMStub([pcfToken isValid:[OCMArg any]]).andReturn(true);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [authHandler fetchTokenWithUserPrompt:self.prompt completionBlock:^void(PCFAuthResponse *response){
        XCTAssertEqual(response.accessToken, self.token);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OCMVerify([authHandler retrieveCredential]);
    OCMVerify([pcfToken isValid:self.token]);
    
    [pcfToken stopMocking];
}

- (void)testFetchTokenCompletionBlockWithRefreshToken {
    id pcfToken = OCMClassMock([PCFToken class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFAuthResponseBlock block = ^void(PCFAuthResponse *response){};
    PCFAFOAuthCredential *credential = [[PCFAFOAuthCredential alloc] initWithOAuthToken:nil tokenType:self.tokenType];
    [credential setRefreshToken:self.refreshToken expiration:[[NSDate alloc] init]];
    
    OCMStub([authHandler retrieveCredential]).andReturn(credential);
    OCMStub([pcfToken isValid:[OCMArg any]]).andReturn(false);
    OCMStub([authHandler refreshTokenWithCredential:[OCMArg any] completionBlock:[OCMArg any]]).andDo(nil);
    
    [authHandler fetchTokenWithUserPrompt:self.prompt completionBlock:block];
    
    OCMVerify([authHandler retrieveCredential]);
    OCMVerify([authHandler refreshTokenWithCredential:credential completionBlock:block]);
}

- (void)testFetchTokenCompletionBlockWithNoTokenAndUserPrompt {
    id pcfToken = OCMClassMock([PCFToken class]);
    PCFAuthResponseBlock block = ^void(PCFAuthResponse *response){};
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFAFOAuthCredential *credential = [[PCFAFOAuthCredential alloc] initWithOAuthToken:self.token tokenType:self.tokenType];
    
    OCMStub([authHandler retrieveCredential]).andReturn(credential);
    OCMStub([pcfToken isValid:[OCMArg any]]).andReturn(false);
    OCMStub([authHandler showLoginControllerWithBlock:[OCMArg any]]).andDo(nil);
    
    [authHandler fetchTokenWithUserPrompt:true completionBlock:block];
    
    OCMVerify([authHandler retrieveCredential]);
    OCMVerify([pcfToken isValid:self.token]);
    OCMVerify([authHandler showLoginControllerWithBlock:block]);
    
    [pcfToken stopMocking];
}

- (void)testFetchTokenCompletionBlockWithNoTokenAndNoUserPrompt {
    id pcfToken = OCMClassMock([PCFToken class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFAFOAuthCredential *credential = [[PCFAFOAuthCredential alloc] initWithOAuthToken:self.token tokenType:self.tokenType];
    
    OCMStub([authHandler retrieveCredential]).andReturn(credential);
    OCMStub([pcfToken isValid:[OCMArg any]]).andReturn(false);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [authHandler fetchTokenWithUserPrompt:false completionBlock:^void(PCFAuthResponse *response){
        XCTAssertNotNil(response.error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OCMVerify([authHandler retrieveCredential]);
    OCMVerify([pcfToken isValid:self.token]);
    
    [pcfToken stopMocking];
}

- (void)testRefreshTokenWithCredentialWith401 {
    id pcfAuthClient = OCMClassMock([PCFAuthClient class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFAuthResponseBlock block = ^void(PCFAuthResponse *response){};
    
    __block PCFAFOAuthCredential *credential = OCMClassMock([PCFAFOAuthCredential class]);
    __block NSError *error = [[NSError alloc] initWithDomain:@"" code:401 userInfo:nil];
    
    OCMStub([authHandler showLoginControllerWithBlock:[OCMArg any]]).andDo(nil);
    OCMStub([pcfAuthClient grantWithRefreshToken:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^block)(PCFAFOAuthCredential *, NSError *);
        [invocation getArgument:&block atIndex:3];
        block(credential, error);
    });
    
    [authHandler refreshTokenWithCredential:credential completionBlock:block];
    
    OCMVerify([authHandler showLoginControllerWithBlock:block]);
    
    [pcfAuthClient stopMocking];
}

- (void)testRefreshTokenWithCredentialWithNoError {
    id pcfAuthClient = OCMClassMock([PCFAuthClient class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    
    __block PCFAFOAuthCredential *requestCredential = OCMClassMock([PCFAFOAuthCredential class]);
    __block PCFAFOAuthCredential *responseCredential = [[PCFAFOAuthCredential alloc] initWithOAuthToken:self.token tokenType:self.tokenType];
    
    OCMStub([authHandler storeCredential:[OCMArg any]]).andDo(nil);
    OCMStub([pcfAuthClient grantWithRefreshToken:[OCMArg any] completionBlock:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^block)(PCFAFOAuthCredential *, NSError *);
        [invocation getArgument:&block atIndex:3];
        block(responseCredential, nil);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [authHandler refreshTokenWithCredential:requestCredential completionBlock:^void(PCFAuthResponse *response){
        XCTAssertEqual(responseCredential.accessToken, response.accessToken);
        XCTAssertNil(response.error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OCMVerify([authHandler storeCredential:responseCredential]);
    
    [pcfAuthClient stopMocking];
}

- (void)testShowLoginController {
    PCFAuthResponseBlock block = ^void(PCFAuthResponse *response){};
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    UIViewController *controller = OCMClassMock([UIViewController class]);
    id application = OCMClassMock([UIApplication class]);
    id<UIApplicationDelegate> delegate = OCMProtocolMock(@protocol(UIApplicationDelegate));
    UIWindow *window = OCMClassMock([UIWindow class]);
    UIViewController *rootController = OCMClassMock([UIViewController class]);
    
    OCMStub([authHandler createLoginViewControllerWithBlock:[OCMArg any]]).andReturn(controller);
    OCMStub([application sharedApplication]).andReturn(application);
    OCMStub([application delegate]).andReturn(delegate);
    OCMStub([delegate window]).andReturn(window);
    OCMStub([window rootViewController]).andReturn(rootController);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    OCMStub([rootController presentViewController:[OCMArg any] animated:true completion:nil]).andDo(^(NSInvocation *invocation) {
        [expectation fulfill];
    });
    
    [authHandler showLoginControllerWithBlock:block];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OCMVerify([authHandler createLoginViewControllerWithBlock:block]);
    OCMVerify([rootController presentViewController:controller animated:true completion:nil]);
    
    [application stopMocking];
}

- (void)testCreateLoginViewController {
    id pcfAuthUtil = OCMClassMock([PCFAuthUtil class]);
    PCFAuthResponseBlock block = ^void(PCFAuthResponse *response){};
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFLoginViewController *controller = OCMClassMock([PCFLoginViewController class]);
    
    OCMStub([pcfAuthUtil findLoginViewController]).andReturn(controller);
    
    XCTAssertEqual(controller, [authHandler createLoginViewControllerWithBlock:block]);
    
    OCMVerify([pcfAuthUtil findLoginViewController]);
    
    [pcfAuthUtil stopMocking];
}

- (void)testCreateLoginViewControllerWithResponseBlock {
    id pcfAuthUtil = OCMClassMock([PCFAuthUtil class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFLoginViewController *controller = [[PCFLoginViewController alloc] init];
    PCFAFOAuthCredential *credential = [[PCFAFOAuthCredential alloc] initWithOAuthToken:self.token tokenType:self.tokenType];
    
    OCMStub([pcfAuthUtil findLoginViewController]).andReturn(controller);
    OCMStub([authHandler storeCredential:[OCMArg any]]).andDo(nil);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [authHandler createLoginViewControllerWithBlock:^(PCFAuthResponse *response) {
        XCTAssertEqual(self.token, response.accessToken);
        XCTAssertNil(response.error);
        [expectation fulfill];
    }];
    
    controller.responseBlock(credential, nil);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OCMVerify([pcfAuthUtil findLoginViewController]);
    OCMVerify([authHandler storeCredential:credential]);
    OCMVerify([controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical]);
    
    [pcfAuthUtil stopMocking];
}

- (void)testCreateLoginViewControllerWithResponseBlockAndError {
    id pcfAuthUtil = OCMClassMock([PCFAuthUtil class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFLoginViewController *controller = [[PCFLoginViewController alloc] init];
    PCFAFOAuthCredential *credential = [[PCFAFOAuthCredential alloc] initWithOAuthToken:self.token tokenType:self.tokenType];
    NSError *error = [[NSError alloc] initWithDomain:@"" code:self.errorCode userInfo:nil];
    
    OCMStub([pcfAuthUtil findLoginViewController]).andReturn(controller);
    OCMStub([authHandler storeCredential:[OCMArg any]]).andDo(nil);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [authHandler createLoginViewControllerWithBlock:^(PCFAuthResponse *response) {
        XCTAssertEqual(self.token, response.accessToken);
        XCTAssertEqual(error, response.error);
        XCTAssertEqual(self.errorCode, response.error.code);
        [expectation fulfill];
    }];
    
    controller.responseBlock(credential, error);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OCMVerify([pcfAuthUtil findLoginViewController]);
    OCMVerify([controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical]);

    [pcfAuthUtil stopMocking];
}

- (void)testCreateLoginViewControllerWithResponseBlockAndNoAccessTokenOrError {
    id pcfAuthUtil = OCMClassMock([PCFAuthUtil class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    PCFLoginViewController *controller = [[PCFLoginViewController alloc] init];
    PCFAFOAuthCredential *credential = [[PCFAFOAuthCredential alloc] initWithOAuthToken:nil tokenType:self.tokenType];
    
    OCMStub([pcfAuthUtil findLoginViewController]).andReturn(controller);
    OCMStub([authHandler storeCredential:[OCMArg any]]).andDo(nil);
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [authHandler createLoginViewControllerWithBlock:^(PCFAuthResponse *response) {
        XCTAssertNil(response.accessToken);
        XCTAssertNotNil(response.error);
        XCTAssertEqual(-1, response.error.code);
        [expectation fulfill];
    }];
    
    controller.responseBlock(credential, nil);
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OCMVerify([pcfAuthUtil findLoginViewController]);
    OCMVerify([controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical]);
    
    [pcfAuthUtil stopMocking];
}

- (void)testInvalidateToken {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    id cookieStorage = OCMClassMock([NSHTTPCookieStorage class]);
    PCFAuthHandler *authHandler = OCMPartialMock([[PCFAuthHandler alloc] init]);
    NSHTTPCookie *cookie = OCMClassMock([NSHTTPCookie class]);
    NSArray *authCookies = [[NSArray alloc] initWithObjects:cookie, nil];
    
    OCMStub([authHandler deleteCredential]).andDo(nil);
    OCMStub([cookieStorage sharedHTTPCookieStorage]).andReturn(cookieStorage);
    OCMStub([cookieStorage cookiesForURL:[OCMArg any]]).andReturn(authCookies);
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig authorizeUrl]).andReturn(self.authUrl);
    
    [authHandler invalidateToken];
    
    OCMVerify([cookieStorage deleteCookie:cookie]);
    [pcfAuthConfig stopMocking];
    [cookieStorage stopMocking];
}

@end
