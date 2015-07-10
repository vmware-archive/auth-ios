//
//  PCFAuthConfigTests.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-11.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PCFAuthConfig.h"

@interface PCFAuthConfigTests : XCTestCase

@property NSString *url;
@property NSString *value;
@property BOOL trustAllSslCertificates;
@property NSArray *pinnedSslCertificateNames;

@end

@implementation PCFAuthConfigTests

static NSString* const PCFTokenUrl = @"pivotal.auth.tokenUrl";
static NSString* const PCFAuthorizeUrl = @"pivotal.auth.authorizeUrl";
static NSString* const PCFRedirectUrl = @"pivotal.auth.redirectUrl";
static NSString* const PCFClientId = @"pivotal.auth.clientId";
static NSString* const PCFClientSecret = @"pivotal.auth.clientSecret";
static NSString* const PCFScopes = @"pivotal.auth.scopes";
static NSString* const PCFTrustAllSslCertificates = @"pivotal.auth.trustAllSslCertificates";
static NSString* const PCFPinnedSslCertificateNames = @"pivotal.auth.pinnedSslCertificateNames";

- (void)setUp {
    [super setUp];
    
    self.url = [NSUUID UUID].UUIDString;
    self.value = [NSUUID UUID].UUIDString;
    self.trustAllSslCertificates = arc4random_uniform(1);
    self.pinnedSslCertificateNames = @[[NSUUID UUID].UUIDString];
}

- (void)testTokenUrl {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    
    OCMStub([config sharedInstance]).andReturn(config);
    OCMStub([config tokenUrl]).andReturn(self.url);
    
    NSString *serviceUrl = [PCFAuthConfig tokenUrl];
    
    XCTAssertEqual(serviceUrl, self.url);
    
    OCMVerify([config sharedInstance]);
    OCMVerify([config tokenUrl]);
    
    [config stopMocking];
}

- (void)testTokenUrlInstance {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    NSDictionary *dict = OCMClassMock([NSDictionary class]);
    
    OCMStub([config values]).andReturn(dict);
    OCMStub([dict objectForKey:[OCMArg any]]).andReturn(self.url);
    
    NSString *serviceUrl = [config tokenUrl];
    
    XCTAssertEqual(serviceUrl, self.url);
    
    OCMVerify([config values]);
    OCMVerify([dict objectForKey:PCFTokenUrl]);
    
    [config stopMocking];
}

- (void)testAuthorizeUrl {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    
    OCMStub([config sharedInstance]).andReturn(config);
    OCMStub([config authorizeUrl]).andReturn(self.url);
    
    NSString *serviceUrl = [PCFAuthConfig authorizeUrl];
    
    XCTAssertEqual(serviceUrl, self.url);
    
    OCMVerify([config sharedInstance]);
    OCMVerify([config authorizeUrl]);
    
    [config stopMocking];
}

- (void)testAuthorizeUrlInstance {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    NSDictionary *dict = OCMClassMock([NSDictionary class]);
    
    OCMStub([config values]).andReturn(dict);
    OCMStub([dict objectForKey:[OCMArg any]]).andReturn(self.url);
    
    NSString *serviceUrl = [config authorizeUrl];
    
    XCTAssertEqual(serviceUrl, self.url);
    
    OCMVerify([config values]);
    OCMVerify([dict objectForKey:PCFAuthorizeUrl]);
    
    [config stopMocking];
}

- (void)testRedirectUrl {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    
    OCMStub([config sharedInstance]).andReturn(config);
    OCMStub([config redirectUrl]).andReturn(self.url);
    
    NSString *serviceUrl = [PCFAuthConfig redirectUrl];
    
    XCTAssertEqual(serviceUrl, self.url);
    
    OCMVerify([config sharedInstance]);
    OCMVerify([config redirectUrl]);
    
    [config stopMocking];
}

- (void)testRedirectUrlInstance {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    NSDictionary *dict = OCMClassMock([NSDictionary class]);
    
    OCMStub([config values]).andReturn(dict);
    OCMStub([dict objectForKey:[OCMArg any]]).andReturn(self.url);
    
    NSString *serviceUrl = [config redirectUrl];
    
    XCTAssertEqual(serviceUrl, self.url);
    
    OCMVerify([config values]);
    OCMVerify([dict objectForKey:PCFRedirectUrl]);
    
    [config stopMocking];
}

- (void)testClientId {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    
    OCMStub([config sharedInstance]).andReturn(config);
    OCMStub([config clientId]).andReturn(self.value);
    
    NSString *serviceUrl = [PCFAuthConfig clientId];
    
    XCTAssertEqual(serviceUrl, self.value);
    
    OCMVerify([config sharedInstance]);
    OCMVerify([config clientId]);
    
    [config stopMocking];
}

- (void)testClientIdInstance {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    NSDictionary *dict = OCMClassMock([NSDictionary class]);
    
    OCMStub([config values]).andReturn(dict);
    OCMStub([dict objectForKey:[OCMArg any]]).andReturn(self.value);
    
    NSString *serviceUrl = [config clientId];
    
    XCTAssertEqual(serviceUrl, self.value);
    
    OCMVerify([config values]);
    OCMVerify([dict objectForKey:PCFClientId]);
    
    [config stopMocking];
}

- (void)testClientSecret {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    
    OCMStub([config sharedInstance]).andReturn(config);
    OCMStub([config clientSecret]).andReturn(self.value);
    
    NSString *serviceUrl = [PCFAuthConfig clientSecret];
    
    XCTAssertEqual(serviceUrl, self.value);
    
    OCMVerify([config sharedInstance]);
    OCMVerify([config clientSecret]);
    
    [config stopMocking];
}

- (void)testClientSecretInstance {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    NSDictionary *dict = OCMClassMock([NSDictionary class]);
    
    OCMStub([config values]).andReturn(dict);
    OCMStub([dict objectForKey:[OCMArg any]]).andReturn(self.value);
    
    NSString *serviceUrl = [config clientSecret];
    
    XCTAssertEqual(serviceUrl, self.value);
    
    OCMVerify([config values]);
    OCMVerify([dict objectForKey:PCFClientSecret]);
    
    [config stopMocking];
}

- (void)testScopes {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    
    OCMStub([config sharedInstance]).andReturn(config);
    OCMStub([config scopes]).andReturn(self.value);
    
    NSString *serviceUrl = [PCFAuthConfig scopes];
    
    XCTAssertEqual(serviceUrl, self.value);
    
    OCMVerify([config sharedInstance]);
    OCMVerify([config scopes]);
    
    [config stopMocking];
}

- (void)testScopesInstance {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    NSDictionary *dict = OCMClassMock([NSDictionary class]);
    
    OCMStub([config values]).andReturn(dict);
    OCMStub([dict objectForKey:[OCMArg any]]).andReturn(self.value);
    
    NSString *serviceUrl = [config scopes];
    
    XCTAssertEqual(serviceUrl, self.value);
    
    OCMVerify([config values]);
    OCMVerify([dict objectForKey:PCFScopes]);
    
    [config stopMocking];
}

- (void)testTrustAllSSLCertificates {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    
    OCMStub([config sharedInstance]).andReturn(config);
    OCMStub([config trustAllSslCertificates]).andReturn(self.trustAllSslCertificates);
    
    BOOL trustAllSSLCertificates = [PCFAuthConfig trustAllSslCertificates];
    
    XCTAssertEqual(trustAllSSLCertificates, self.trustAllSslCertificates);
    
    OCMVerify([config sharedInstance]);
    OCMVerify([config trustAllSslCertificates]);
    
    [config stopMocking];
}

- (void)testTrustAllSSLCertificatesInstace {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    NSDictionary *dict = OCMClassMock([NSDictionary class]);
    
    OCMStub([config values]).andReturn(dict);
    OCMStub([dict objectForKey:[OCMArg any]]).andReturn([NSNumber numberWithBool:self.trustAllSslCertificates]);
    
    BOOL trustAllSSLCertificates = [config trustAllSslCertificates];
    
    XCTAssertEqual(trustAllSSLCertificates, self.trustAllSslCertificates);
    
    OCMVerify([config values]);
    OCMVerify([dict objectForKey:PCFTrustAllSslCertificates]);
    
    [config stopMocking];
}

- (void)testPinnedSSLCertificateNames {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    
    OCMStub([config sharedInstance]).andReturn(config);
    OCMStub([config pinnedSslCertificateNames]).andReturn(self.pinnedSslCertificateNames);
    
    NSArray *pinnedSSLCertificateNames = [PCFAuthConfig pinnedSslCertificateNames];
    
    XCTAssertEqual(pinnedSSLCertificateNames, self.pinnedSslCertificateNames);
    
    OCMVerify([config sharedInstance]);
    OCMVerify([config pinnedSslCertificateNames]);
    
    [config stopMocking];
}

- (void)testPinnedSSLCertificateNamesInstance {
    id config = OCMPartialMock([[PCFAuthConfig alloc] init]);
    NSDictionary *dict = OCMClassMock([NSDictionary class]);
    
    OCMStub([config values]).andReturn(dict);
    OCMStub([dict objectForKey:[OCMArg any]]).andReturn(self.pinnedSslCertificateNames);
    
    NSArray *pinnedSSLCertificateNames = [config pinnedSslCertificateNames];
    
    XCTAssertEqual(pinnedSSLCertificateNames, self.pinnedSslCertificateNames);
    
    OCMVerify([config values]);
    OCMVerify([dict objectForKey:PCFPinnedSslCertificateNames]);
    
    [config stopMocking];
}

- (void)testValues {
    id config = [[PCFAuthConfig alloc] init];
    id bundle = OCMClassMock([NSBundle class]);
    id dict = OCMClassMock([NSDictionary class]);
    NSString *path = [NSUUID UUID].UUIDString;
    
    OCMStub([bundle mainBundle]).andReturn(bundle);
    OCMStub([bundle pathForResource:[OCMArg any] ofType:[OCMArg any]]).andReturn(path);
    OCMStub([dict alloc]).andReturn(dict);
    OCMStub([dict initWithContentsOfFile:[OCMArg any]]).andReturn(dict);
    
    XCTAssertEqual([config values], dict);
    
    OCMVerify([bundle pathForResource:@"Pivotal" ofType:@"plist"]);
    OCMVerify([dict initWithContentsOfFile:path]);
    
    [bundle stopMocking];
    [dict stopMocking];
}

@end