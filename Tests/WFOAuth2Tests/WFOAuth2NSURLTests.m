//
//  WFOAuth2CredentialTestCase.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WFOAuth2/NSURL+WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2NSURLTests : XCTestCase

@end

@implementation WFOAuth2NSURLTests

- (void)testAppendingQueryItems {
    NSURL *URL = [NSURL URLWithString:@"https://apple.com/test?foo=bar"];
    NSArray<NSURLQueryItem *> *queryItems = @[[NSURLQueryItem queryItemWithName:@"key" value:@"value"],
                                              [NSURLQueryItem queryItemWithName:@"lol" value:@"wow"]];
    
    XCTAssertEqualObjects([URL wfo_URLByAppendingQueryItems:nil], URL);
    XCTAssertEqualObjects([URL wfo_URLByAppendingQueryItems:queryItems], [NSURL URLWithString:@"https://apple.com/test?foo=bar&key=value&lol=wow"]);
}

- (void)testEqualityOfRedirectURIs {
    NSURL *redirectURI = [NSURL URLWithString:@"https://apple.com/callback/test"];
    
    XCTAssertTrue([[NSURL URLWithString:@"https://apple.com/callback/test?code=food&test=bar"] wfo_isEqualToRedirectURI:redirectURI]);
    XCTAssertTrue([[NSURL URLWithString:@"https://apple.com/callback/test?code=foo#testing"] wfo_isEqualToRedirectURI:redirectURI]);
    XCTAssertTrue([[NSURL URLWithString:@"https://apple.com/callback/test/"] wfo_isEqualToRedirectURI:redirectURI]);

    XCTAssertFalse([[NSURL URLWithString:@"https:apple.com/callback/test"] wfo_isEqualToRedirectURI:redirectURI]);
    XCTAssertFalse([[NSURL URLWithString:@"http://apple.com/callback/test"] wfo_isEqualToRedirectURI:redirectURI]);
    XCTAssertFalse([[NSURL URLWithString:@"https://apple.com/callback/test/foo/"] wfo_isEqualToRedirectURI:redirectURI]);
    XCTAssertFalse([[NSURL URLWithString:@"https://apple.com/callback/"] wfo_isEqualToRedirectURI:redirectURI]);
    XCTAssertFalse([[NSURL URLWithString:@"https://apples.com/callback/test"] wfo_isEqualToRedirectURI:redirectURI]);
    XCTAssertFalse([[NSURL URLWithString:@"https://apple.com/callback/tests"] wfo_isEqualToRedirectURI:redirectURI]);
}

@end

NS_ASSUME_NONNULL_END
