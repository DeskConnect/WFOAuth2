//
//  WFOAuth2CredentialTestCase.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>

@interface WFOAuth2FormEncodingTests : XCTestCase

@end

@implementation WFOAuth2FormEncodingTests

- (void)testEncodingNewlines {
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request wfo_setBodyWithQueryItems:@[[NSURLQueryItem queryItemWithName:@"\rkey\r\n" value:@"\nvalue"]]];
    XCTAssertEqualObjects(request.HTTPBody, [@"%0Dkey%0D%0A=%0D%0Avalue" dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testEncodingOrder {
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    [request wfo_setBodyWithQueryItems:@[[NSURLQueryItem queryItemWithName:@"key1" value:@"value1"],
                                        [NSURLQueryItem queryItemWithName:@"key2" value:@"value2"]]];
    XCTAssertEqualObjects(request.HTTPBody, [@"key1=value1&key2=value2" dataUsingEncoding:NSUTF8StringEncoding]);
    
    [request wfo_setBodyWithQueryItems:@[[NSURLQueryItem queryItemWithName:@"key2" value:@"value2"],
                                        [NSURLQueryItem queryItemWithName:@"key1" value:@"value1"]]];
    XCTAssertEqualObjects(request.HTTPBody, [@"key2=value2&key1=value1" dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testEncodingSpaces {
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    [request wfo_setBodyWithQueryItems:@[[NSURLQueryItem queryItemWithName:@"key with space" value:@"1+2+3+4+5 6"]]];
    XCTAssertEqualObjects(request.HTTPBody, [@"key+with+space=1%2B2%2B3%2B4%2B5+6" dataUsingEncoding:NSUTF8StringEncoding]);
}

@end
