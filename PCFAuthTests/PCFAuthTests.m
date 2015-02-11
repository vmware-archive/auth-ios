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

@property BOOL prompt;

@end

@implementation PCFAuthTests

- (void)setUp {
    [super setUp];
    
    self.prompt = arc4random_uniform(2);

}

- (void)testFetchTokenWithUserPrompt {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    PCFAuthResponse *response = OCMClassMock([PCFAuthResponse class]);
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    OCMStub([handler fetchTokenWithUserPrompt:self.prompt]).andReturn(response);
    
    XCTAssertEqual(response, [PCFAuth fetchTokenWithUserPrompt:self.prompt]);
    
    [pcfAuth stopMocking];
}

- (void)testFetchTokenWithUserPromptCompletionBlock {
    id pcfAuth = OCMClassMock([PCFAuth class]);
    PCFAuthHandler *handler = OCMClassMock([PCFAuthHandler class]);
    PCFAuthResponseBlock block = ^void(PCFAuthResponse* response) {};
    
    OCMStub([pcfAuth handler]).andReturn(handler);
    
    [PCFAuth fetchTokenWithUserPrompt:self.prompt completionBlock:block];
    
    OCMVerify([handler fetchTokenWithUserPrompt:self.prompt completionBlock:block]);
    
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

@end
