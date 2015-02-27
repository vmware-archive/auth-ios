//
//  PCFAuthClientTests.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-10.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PCFAFOAuth2Manager.h"
#import "PCFAuthConfig.h"
#import "PCFAuthClient.h"
#import "PCFAuthCodeHandler.h"

@interface PCFAuthClient ()

+ (PCFAFOAuth2Manager *)manager;

+ (NSURL *)baseUrl;

+ (NSURL *)tokenUrl;

+ (NSURLRequest *)authCodeRequest;

+ (NSDictionary *)authCodeParams;

@end

@interface PCFAuthClientTests : XCTestCase

@property NSString *urlString;
@property NSURL *url;

@end

@implementation PCFAuthClientTests

- (void)setUp {
    [super setUp];
    
    self.urlString = [NSString stringWithFormat:@"http://%@.com", [NSUUID UUID].UUIDString];
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@.com", [NSUUID UUID].UUIDString]];
}

- (void)testTokenUrl {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig tokenUrl]).andReturn(self.urlString);
    
    XCTAssertEqual(self.urlString, [[PCFAuthClient tokenUrl] absoluteString]);
    
    [pcfAuthConfig stopMocking];
}

- (void)testBaseUrl {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);

    NSString *scheme = [NSUUID UUID].UUIDString;
    NSString *host = [NSUUID UUID].UUIDString;
    NSString *path = [NSUUID UUID].UUIDString;
    NSString *tokenUrl = [NSString stringWithFormat:@"%@://%@/%@", scheme, host, path];
    
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig tokenUrl]).andReturn(tokenUrl);
    
    XCTAssertEqualObjects(scheme, [[PCFAuthClient baseUrl] scheme]);
    XCTAssertEqualObjects(host, [[PCFAuthClient baseUrl] host]);
    XCTAssertEqualObjects(@"", [[PCFAuthClient baseUrl] path]);
    
    [pcfAuthConfig stopMocking];
}

- (void)testManager {
    id pcfAFOAuth2Manager = OCMClassMock([PCFAFOAuth2Manager class]);
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    
    NSString *clientId = [NSUUID UUID].UUIDString;
    NSString *clientSecret = [NSUUID UUID].UUIDString;
    
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig clientId]).andReturn(clientId);
    OCMStub([pcfAuthConfig clientSecret]).andReturn(clientSecret);
    OCMStub([pcfAuthClient baseUrl]).andReturn(self.url);
    OCMStub([pcfAFOAuth2Manager clientWithBaseURL:[OCMArg any] clientID:[OCMArg any] secret:[OCMArg any]]).andReturn(pcfAFOAuth2Manager);
    
    XCTAssertEqual(pcfAFOAuth2Manager, [PCFAuthClient manager]);
    
    OCMVerify([pcfAFOAuth2Manager clientWithBaseURL:self.url clientID:clientId secret:clientSecret]);
    
    [pcfAFOAuth2Manager stopMocking];
    [pcfAuthConfig stopMocking];
    [pcfAuthClient stopMocking];
}

- (void)testGrantWithRefreshTokenSuccess {
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    PCFAFOAuth2Manager *manager = OCMClassMock([PCFAFOAuth2Manager class]);
    PCFAFOAuthCredential *credential = OCMClassMock([PCFAFOAuthCredential class]);
    
    NSString *refreshToken = [NSUUID UUID].UUIDString;
    
    OCMStub([pcfAuthClient manager]).andReturn(manager);
    OCMStub([pcfAuthClient tokenUrl]).andReturn(self.url);
    OCMStub([manager authenticateUsingOAuthWithURLString:[OCMArg any] refreshToken:[OCMArg any] success:[OCMArg any] failure:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^successBlock)(PCFAFOAuthCredential *credential);
        [invocation getArgument:&successBlock atIndex:4];
        successBlock(credential);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [PCFAuthClient grantWithRefreshToken:refreshToken completionBlock:^(PCFAFOAuthCredential *c, NSError *error) {
        XCTAssertEqual(credential, c);
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    [pcfAuthClient stopMocking];
}

- (void)testGrantWithRefreshTokenFailure {
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    PCFAFOAuth2Manager *manager = OCMClassMock([PCFAFOAuth2Manager class]);
    NSError *error = OCMClassMock([NSError class]);
    
    NSString *refreshToken = [NSUUID UUID].UUIDString;
    
    OCMStub([pcfAuthClient manager]).andReturn(manager);
    OCMStub([pcfAuthClient tokenUrl]).andReturn(self.url);
    OCMStub([manager authenticateUsingOAuthWithURLString:[OCMArg any] refreshToken:[OCMArg any] success:[OCMArg any] failure:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^failureBlock)(NSError *error);
        [invocation getArgument:&failureBlock atIndex:5];
        failureBlock(error);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [PCFAuthClient grantWithRefreshToken:refreshToken completionBlock:^(PCFAFOAuthCredential *credential, NSError *e) {
        XCTAssertEqual(error, e);
        XCTAssertNil(credential);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    [pcfAuthClient stopMocking];
}

- (void)testGrantWithUsernameSuccess {
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    PCFAFOAuth2Manager *manager = OCMClassMock([PCFAFOAuth2Manager class]);
    PCFAFOAuthCredential *credential = OCMClassMock([PCFAFOAuthCredential class]);
    
    NSString *username = [NSUUID UUID].UUIDString;
    NSString *password = [NSUUID UUID].UUIDString;
    
    OCMStub([pcfAuthClient manager]).andReturn(manager);
    OCMStub([pcfAuthClient tokenUrl]).andReturn(self.url);
    OCMStub([manager authenticateUsingOAuthWithURLString:[OCMArg any] username:[OCMArg any] password:[OCMArg any] scope:[OCMArg any] success:[OCMArg any] failure:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^successBlock)(PCFAFOAuthCredential *credential);
        [invocation getArgument:&successBlock atIndex:6];
        successBlock(credential);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [PCFAuthClient grantWithUsername:username password:password completionBlock:^(PCFAFOAuthCredential *c, NSError *error) {
        XCTAssertEqual(credential, c);
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    [pcfAuthClient stopMocking];
}

- (void)testGrantWithUsernameFailure {
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    PCFAFOAuth2Manager *manager = OCMClassMock([PCFAFOAuth2Manager class]);
    NSError *error = OCMClassMock([NSError class]);
    
    NSString *username = [NSUUID UUID].UUIDString;
    NSString *password = [NSUUID UUID].UUIDString;
    
    OCMStub([pcfAuthClient manager]).andReturn(manager);
    OCMStub([pcfAuthClient tokenUrl]).andReturn(self.url);
    OCMStub([manager authenticateUsingOAuthWithURLString:[OCMArg any] username:[OCMArg any] password:[OCMArg any] scope:[OCMArg any] success:[OCMArg any] failure:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^failureBlock)(NSError *error);
        [invocation getArgument:&failureBlock atIndex:7];
        failureBlock(error);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [PCFAuthClient grantWithUsername:username password:password completionBlock:^(PCFAFOAuthCredential *credential, NSError *e) {
        XCTAssertEqual(error, e);
        XCTAssertNil(credential);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    [pcfAuthClient stopMocking];
}

- (void)testGrantWithAuthCodeSuccess {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    PCFAFOAuth2Manager *manager = OCMClassMock([PCFAFOAuth2Manager class]);
    PCFAFOAuthCredential *credential = OCMClassMock([PCFAFOAuthCredential class]);
    
    NSString *code = [NSUUID UUID].UUIDString;
    
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig redirectUrl]).andReturn(self.urlString);
    OCMStub([pcfAuthClient manager]).andReturn(manager);
    OCMStub([pcfAuthClient tokenUrl]).andReturn(self.url);
    OCMStub([manager authenticateUsingOAuthWithURLString:[OCMArg any] code:[OCMArg any] redirectURI:[OCMArg any] success:[OCMArg any] failure:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^successBlock)(PCFAFOAuthCredential *credential);
        [invocation getArgument:&successBlock atIndex:5];
        successBlock(credential);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [PCFAuthClient grantWithAuthCode:code completionBlock:^(PCFAFOAuthCredential *c, NSError *error) {
        XCTAssertEqual(credential, c);
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    [pcfAuthClient stopMocking];
    [pcfAuthConfig stopMocking];
}

- (void)testGrantWithAuthCodeFailure {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    PCFAFOAuth2Manager *manager = OCMClassMock([PCFAFOAuth2Manager class]);
    NSError *error = OCMClassMock([NSError class]);
    
    NSString *code = [NSUUID UUID].UUIDString;
    
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig redirectUrl]).andReturn(self.urlString);
    OCMStub([pcfAuthClient manager]).andReturn(manager);
    OCMStub([pcfAuthClient tokenUrl]).andReturn(self.url);
    OCMStub([manager authenticateUsingOAuthWithURLString:[OCMArg any] code:[OCMArg any] redirectURI:[OCMArg any] success:[OCMArg any] failure:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^failureBlock)(NSError *error);
        [invocation getArgument:&failureBlock atIndex:6];
        failureBlock(error);
    });
    
    XCTestExpectation *expectation = [self expectationWithDescription:@""];
    
    [PCFAuthClient grantWithAuthCode:code completionBlock:^(PCFAFOAuthCredential *credential, NSError *e) {
        XCTAssertEqual(error, e);
        XCTAssertNil(credential);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    [pcfAuthClient stopMocking];
    [pcfAuthConfig stopMocking];
}

- (void)testGrantWithAuthCodeFlow {
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    id pcfAuthCodeHandler = OCMClassMock([PCFAuthCodeHandler class]);
    NSURLRequest *urlRequest = OCMClassMock([NSURLRequest class]);
    UIWebView *webview = OCMClassMock([UIWebView class]);
    
    NSString *code = [NSUUID UUID].UUIDString;
    
    PCFAuthClientBlock block = ^(PCFAFOAuthCredential *credential, NSError *error) {};
    
    OCMStub([pcfAuthClient authCodeRequest]).andReturn(urlRequest);
    OCMStub([pcfAuthCodeHandler alloc]).andReturn(pcfAuthCodeHandler);
    OCMStub([pcfAuthCodeHandler initWithWebView:[OCMArg any]]).andReturn(pcfAuthCodeHandler);
    OCMStub([pcfAuthClient grantWithAuthCode:[OCMArg any] completionBlock:[OCMArg any]]).andDo(nil);
    OCMStub([pcfAuthCodeHandler load:[OCMArg any] completionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^completionBlock)(NSString *code);
        [invocation getArgument:&completionBlock atIndex:3];
        completionBlock(code);
    });
    
    [PCFAuthClient grantWithAuthCodeFlow:webview completionBlock:block];
    
    OCMVerify([pcfAuthCodeHandler load:urlRequest completionHandler:[OCMArg any]]);
    OCMVerify([pcfAuthClient grantWithAuthCode:code completionBlock:block]);
    
    [pcfAuthClient stopMocking];
    [pcfAuthCodeHandler stopMocking];
}

- (void)testAuthCodeRequest {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    id pcfAuthClient = OCMPartialMock([[PCFAuthClient alloc] init]);
    NSDictionary *dictionary = @{ @"key1": @"value1", @"key2": @"value2" };
    NSString *encodedParams = PCFAFQueryStringFromParametersWithEncoding(dictionary, NSUTF8StringEncoding);
    NSURL *urlWithParams = [NSURL URLWithString:[self.urlString stringByAppendingFormat:@"?%@", encodedParams]];
    
    OCMStub([pcfAuthClient authCodeParams]).andReturn(dictionary);
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig authorizeUrl]).andReturn(self.urlString);
    
    XCTAssertEqualObjects([NSURLRequest requestWithURL:urlWithParams], [PCFAuthClient authCodeRequest]);
    
    [pcfAuthConfig stopMocking];
    [pcfAuthClient stopMocking];
}

- (void)testAuthCodeParams {
    id pcfAuthConfig = OCMClassMock([PCFAuthConfig class]);
    id uuid = OCMClassMock([NSUUID class]);
    
    NSString *uuidString = [NSUUID UUID].UUIDString;
    NSString *clientId = [NSUUID UUID].UUIDString;
    
    OCMStub([uuid UUID]).andReturn(uuid);
    OCMStub([uuid UUIDString]).andReturn(uuidString);
    OCMStub([pcfAuthConfig sharedInstance]).andReturn(pcfAuthConfig);
    OCMStub([pcfAuthConfig redirectUrl]).andReturn(self.urlString);
    OCMStub([pcfAuthConfig clientId]).andReturn(clientId);
    
    NSDictionary *dictionary = [PCFAuthClient authCodeParams];
    
    XCTAssertEqual(uuidString, dictionary[@"state"]);
    XCTAssertEqual(self.urlString, dictionary[@"redirect_uri"]);
    XCTAssertEqual(clientId, dictionary[@"client_id"]);
    XCTAssertEqualObjects(@"force", dictionary[@"approval_prompt"]);
    XCTAssertEqualObjects(@"code", dictionary[@"response_type"]);
    XCTAssertEqualObjects(@"openid offline_access", dictionary[@"scope"]);
    
    [pcfAuthConfig stopMocking];
    [uuid stopMocking];
}

@end
