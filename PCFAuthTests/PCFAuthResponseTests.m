//
//  PCFAuthResponseTests.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-11.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PCFAuthResponse.h"

@interface PCFAuthResponseTests : XCTestCase

@end

@implementation PCFAuthResponseTests


- (void)testInitWithAccessTokenAndError {
    NSString *token = [[NSUUID UUID] UUIDString];
    NSError *error = OCMClassMock([NSError class]);
    
    PCFAuthResponse *response = [[PCFAuthResponse alloc] initWithAccessToken:token error:error];
    
    XCTAssertEqual(token, response.accessToken);
    XCTAssertEqual(error, response.error);
}

@end
