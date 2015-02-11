//
//  PCFTokenTests.m
//  PCFAuth
//
//  Created by DX122-XL on 2015-02-11.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PCFToken.h"

@interface PCFToken ()

+ (BOOL)parseToken:(NSString *)accessToken;

+ (int)calculateExpirationFromToken:(NSString *)accessToken;

+ (int)decodeExpirationFromToken:(NSString *)accessToken;

+ (NSString *)addBase64Padding:(NSString *)someString;

@end

@interface PCFTokenTests : XCTestCase

@property NSString *token;
@property BOOL valid;

@end

@implementation PCFTokenTests

static int PCFExpirationWindow = 30;

- (void)setUp {
    [super setUp];

    self.token = [[NSUUID UUID] UUIDString];
    self.valid = arc4random_uniform(2);
}

- (void)testIsValidWithNilToken {
    XCTAssertFalse([PCFToken isValid:nil]);
}

- (void)testIsValidWithNonNilToken {
    id pcfToken = OCMPartialMock([[PCFToken alloc] init]);
    
    OCMStub([pcfToken parseToken:[OCMArg any]]).andReturn(self.valid);
    
    XCTAssertEqual(self.valid, [PCFToken isValid:self.token]);
    
    OCMVerify([pcfToken parseToken:self.token]);
    
    [pcfToken stopMocking];
}

- (void)testParseTokenWithEmptyToken {
    XCTAssertTrue([PCFToken parseToken:@""]);
}

- (void)testParseTokenWithInvalidToken {
    XCTAssertTrue([PCFToken parseToken:self.token]);
}

- (void)testParseTokenWithValidTokenNotExpired {
    id pcfToken = OCMPartialMock([[PCFToken alloc] init]);
    id string = OCMClassMock([NSString class]);
    NSArray *parts = @[[NSUUID UUID].UUIDString, self.token];
    
    OCMStub([string componentsSeparatedByString:[OCMArg any]]).andReturn(parts);
    OCMStub([pcfToken addBase64Padding:[OCMArg any]]).andReturn(self.token);
    OCMStub([pcfToken calculateExpirationFromToken:[OCMArg any]]).andReturn(PCFExpirationWindow + 1);
    
    XCTAssertTrue([PCFToken parseToken:string]);
    
    OCMVerify([string componentsSeparatedByString:@"."]);
    OCMVerify([pcfToken addBase64Padding:self.token]);
    OCMVerify([pcfToken calculateExpirationFromToken:self.token]);
    
    [pcfToken stopMocking];
    [string stopMocking];
}

- (void)testParseTokenWithValidTokenExpired {
    id pcfToken = OCMPartialMock([[PCFToken alloc] init]);
    id string = OCMClassMock([NSString class]);
    NSArray *parts = @[[NSUUID UUID].UUIDString, self.token];
    
    OCMStub([string componentsSeparatedByString:[OCMArg any]]).andReturn(parts);
    OCMStub([pcfToken addBase64Padding:[OCMArg any]]).andReturn(self.token);
    OCMStub([pcfToken calculateExpirationFromToken:[OCMArg any]]).andReturn(PCFExpirationWindow - 1);
    
    XCTAssertFalse([PCFToken parseToken:string]);
    
    OCMVerify([string componentsSeparatedByString:@"."]);
    OCMVerify([pcfToken addBase64Padding:self.token]);
    OCMVerify([pcfToken calculateExpirationFromToken:self.token]);
    
    [pcfToken stopMocking];
    [string stopMocking];
}

- (void)testCalculateExpirationWithValidToken {
    id pcfToken = OCMPartialMock([[PCFToken alloc] init]);
    id date = OCMClassMock([NSDate class]);
    int expiration = arc4random_uniform(100) + PCFExpirationWindow;
    
    OCMStub([date date]).andReturn(date);
    OCMStub([date timeIntervalSince1970]).andReturn(expiration);
    OCMStub([pcfToken decodeExpirationFromToken:[OCMArg any]]).andReturn(expiration);
    
    XCTAssertTrue([PCFToken calculateExpirationFromToken:self.token] == 0);
    
    OCMVerify([pcfToken decodeExpirationFromToken:self.token]);
    
    [pcfToken stopMocking];
    [date stopMocking];
}

- (void)testCalculateExpirationWithInvalidToken {
    id pcfToken = OCMPartialMock([[PCFToken alloc] init]);
    NSException *exception = OCMClassMock([NSException class]);
    
    OCMStub([pcfToken decodeExpirationFromToken:[OCMArg any]]).andThrow(exception);
    
    XCTAssertTrue([PCFToken calculateExpirationFromToken:self.token] == (PCFExpirationWindow + 1));
    
    OCMVerify([pcfToken decodeExpirationFromToken:self.token]);
    
    [pcfToken stopMocking];
}

- (void)testDecodeExpirationWithExpKey {
    id pcfToken = OCMPartialMock([[PCFToken alloc] init]);
    id data = OCMClassMock([NSData class]);
    id jsonSerialization = OCMClassMock([NSJSONSerialization class]);
    int expiration = arc4random_uniform(100);
    
    NSDictionary *dictionary = @{ @"exp" : [NSString stringWithFormat:@"%d", expiration] };
    
    OCMStub([data alloc]).andReturn(data);
    OCMStub([data initWithBase64EncodedString:[OCMArg any] options:0]).andReturn(data);
    OCMStub([jsonSerialization JSONObjectWithData:[OCMArg any] options:0 error:nil]).andReturn(dictionary);
    
    XCTAssertTrue([PCFToken decodeExpirationFromToken:self.token] == expiration);
    
    OCMVerify([[data alloc] initWithBase64EncodedString:self.token options:0]);
    OCMVerify([jsonSerialization JSONObjectWithData:data options:0 error:nil]);
    
    [pcfToken stopMocking];
    [data stopMocking];
    [jsonSerialization stopMocking];
}

- (void)testDecodeExpirationWithoutExpKey {
    id pcfToken = OCMPartialMock([[PCFToken alloc] init]);
    id data = OCMClassMock([NSData class]);
    id jsonSerialization = OCMClassMock([NSJSONSerialization class]);
    int expiration = arc4random_uniform(100);
    
    NSDictionary *dictionary = @{ @"not-exp" : [NSString stringWithFormat:@"%d", expiration] };
    
    OCMStub([data alloc]).andReturn(data);
    OCMStub([data initWithBase64EncodedString:[OCMArg any] options:0]).andReturn(data);
    OCMStub([jsonSerialization JSONObjectWithData:[OCMArg any] options:0 error:nil]).andReturn(dictionary);
    
    XCTAssertTrue([PCFToken decodeExpirationFromToken:self.token] == 0);
    
    OCMVerify([[data alloc] initWithBase64EncodedString:self.token options:0]);
    OCMVerify([jsonSerialization JSONObjectWithData:data options:0 error:nil]);
    
    [pcfToken stopMocking];
    [data stopMocking];
    [jsonSerialization stopMocking];
}

- (void)testAddBase64Padding {
    NSString *string = [NSUUID UUID].UUIDString;
    
    NSString *string1 = [string substringToIndex:string.length - 1];
    NSString *string2 = [string substringToIndex:string.length - 2];
    NSString *string3 = [string substringToIndex:string.length - 3];
    
    NSString *string1Padded = [NSString stringWithFormat:@"%@=", string1];
    NSString *string2Padded = [NSString stringWithFormat:@"%@==", string2];
    NSString *string3Padded = [NSString stringWithFormat:@"%@===", string3];
    
    XCTAssertEqualObjects(string1Padded, [PCFToken addBase64Padding:string1]);
    XCTAssertEqualObjects(string2Padded, [PCFToken addBase64Padding:string2]);
    XCTAssertEqualObjects(string3Padded, [PCFToken addBase64Padding:string3]);
}

@end
