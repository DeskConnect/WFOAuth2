//
//  WFOAuth2CredentialTestCase.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WFOAuth2/WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2CredentialTestCase : XCTestCase

@end

@implementation WFOAuth2CredentialTestCase

- (void)testParsingResponseObject {
    NSDictionary *responseObject = @{@"access_token": @"abc123",
                                     @"refresh_token": @"abc456",
                                     @"expires_in": @3600,
                                     @"token_type": @"sometype"};
    
    WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];
    
    XCTAssertNotNil(credential);
    XCTAssertEqualObjects(credential.accessToken, @"abc123");
    XCTAssertEqualObjects(credential.refreshToken, @"abc456");
    XCTAssertEqualObjects(credential.tokenType, @"sometype");
    XCTAssertEqualWithAccuracy(credential.expirationDate.timeIntervalSinceReferenceDate, NSDate.timeIntervalSinceReferenceDate + 3600, 0.5f);
}

- (void)testDefaultTokenType {
    NSDictionary *responseObject = @{@"access_token": @"abc123",
                                     @"refresh_token": @"abc456",
                                     @"expires_in": @3600};
    
    WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];
    
    XCTAssertEqualObjects(credential.tokenType, @"bearer");
}

- (void)testInvalidResponseObject {
    NSDictionary *responseObject = @{@"access_token": @"",
                                     @"refresh_token": @"abc456"};
    
    WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];
    
    XCTAssertNil(credential);
}

- (void)testSerialization {
    NSDictionary *responseObject = @{@"access_token": @"abc123",
                                     @"refresh_token": @"abc456",
                                     @"expires_in": @3600,
                                     @"token_type": @"sometype"};
    
    WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];

    NSMutableData *data = [NSMutableData new];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    archiver.requiresSecureCoding = YES;
    [archiver encodeObject:credential forKey:NSKeyedArchiveRootObjectKey];
    [archiver finishEncoding];
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    unarchiver.requiresSecureCoding = YES;
    WFOAuth2Credential *savedCredential = [unarchiver decodeObjectOfClass:[WFOAuth2Credential class] forKey:NSKeyedArchiveRootObjectKey];
    
    XCTAssertEqualObjects(credential, savedCredential);
}

- (void)testCopying {
    NSDictionary *responseObject = @{@"access_token": @"abc123",
                                     @"refresh_token": @"abc456",
                                     @"expires_in": @3600,
                                     @"token_type": @"sometype"};
    
    WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];
    WFOAuth2Credential *copy = [credential copy];
    
    XCTAssertEqual(credential, copy);
    XCTAssertEqualObjects(credential, copy);
}

@end

NS_ASSUME_NONNULL_END
