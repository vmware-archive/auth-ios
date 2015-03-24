//
//  PCFAuthTests.m
//  PCFAuthTests
//
//  Created by DX122-XL on 2014-12-17.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <PCFAuth/PCFAuth.h>
#import "PCFAuthHandler.h"
#import "PCFAFOAuth2Manager.h"

@interface PCFAuth ()

+ (PCFAuthHandler *)handler;

@end

@interface PCFAuthTests : XCTestCase

@property BOOL disable;

@end

@implementation PCFAuthTests

- (void)setUp {
    [super setUp];
    
    self.disable = arc4random_uniform(2);

}

- (void)testRegisterLoginObserverBlock {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFLoginObserverBlock block = ^() {};
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth registerLoginObserverBlock:block];
    
    OCMVerify([handler registerLoginObserverBlock:block]);
    
    [pcfAuth stopMocking];
}

- (void)testUnregisterLoginObserverBlock {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth unregisterLoginObserverBlock];
    
    OCMVerify([handler registerLoginObserverBlock:nil]);
    
    [pcfAuth stopMocking];
}

- (void)testRegisterLogoutObserverBlock {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFLogoutObserverBlock block = ^() {};
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth registerLogoutObserverBlock:block];
    
    OCMVerify([handler registerLogoutObserverBlock:block]);
    
    [pcfAuth stopMocking];
}

- (void)testUnregisterLogoutObserverBlock {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth unregisterLogoutObserverBlock];
    
    OCMVerify([handler registerLogoutObserverBlock:nil]);
    
    [pcfAuth stopMocking];
}

- (void)testFetchToken {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    PCFAuthResponse *response = OCMClassMock([PCFAuthResponse class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    OCMStub([handler fetchToken]).andReturn(response);
    
    XCTAssertEqual(response, [PCFAuth fetchToken]);
    
    [pcfAuth stopMocking];
}

- (void)testFetchTokenWithCompletionBlock {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    PCFAuthResponseBlock block = ^void(PCFAuthResponse* response) {};
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth fetchTokenWithCompletionBlock:block];
    
    OCMVerify([handler fetchTokenWithCompletionBlock:block]);
    
    [pcfAuth stopMocking];
}

- (void)testInvalidateToken {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth invalidateToken];
    
    OCMVerify([handler invalidateToken]);
    
    [pcfAuth stopMocking];
}

- (void)testLogout {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth logout];
    
    OCMVerify([handler logout]);
    
    [pcfAuth stopMocking];
}

- (void)testDisableUserPrompt {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth disableUserPrompt:self.disable];
    
    OCMVerify([handler disableUserPrompt:self.disable]);
    
    [pcfAuth stopMocking];

}


@end
