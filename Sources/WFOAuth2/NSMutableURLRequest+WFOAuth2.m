//
//  NSMutableURLRequest+WFOAuth2.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Credential.h>

NS_ASSUME_NONNULL_BEGIN

// Implemented per http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4.1
static inline NSString * WFHTTPFormEncodedString(NSString * __nullable string) {
    if (!string)
        return @"";
    
    NSMutableCharacterSet *alphanumericAndSpaces = [[NSCharacterSet alphanumericCharacterSet] mutableCopy];
    [alphanumericAndSpaces formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [alphanumericAndSpaces addCharactersInString:@"-_.~"]; // RFC 3986 section 2.2

    string = [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:alphanumericAndSpaces];
    return [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@"+"];
}

static inline NSData * WFHTTPBodyFromQueryItems(NSArray<NSURLQueryItem *> * __nullable queryItems) {
    if (!queryItems.count)
        return [NSData new];
    
    NSMutableString *string = [NSMutableString new];
    for (NSURLQueryItem *queryItem in queryItems)
        [string appendFormat:@"%@=%@&", WFHTTPFormEncodedString(queryItem.name), WFHTTPFormEncodedString(queryItem.value)];
    [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

@implementation NSMutableURLRequest (WFOAuth2)

- (void)wfo_setAuthorizationWithCredential:(nullable WFOAuth2Credential *)credential {
    if (credential.valid && [credential.tokenType compare:@"bearer" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self setValue:[@"Bearer " stringByAppendingString:credential.accessToken] forHTTPHeaderField:@"Authorization"];
    } else {
        [self setValue:nil forHTTPHeaderField:@"Authorization"];
    }
}

- (void)wfo_setAuthorizationWithUsername:(NSString *)username password:(nullable NSString *)password {
    NSParameterAssert(username);
    NSString *authenticaton = [[[NSString stringWithFormat:@"%@:%@", username, (password ?: @"")] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    [self setValue:[@"Basic " stringByAppendingString:authenticaton] forHTTPHeaderField:@"Authorization"];
}

- (void)wfo_setBodyWithQueryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems {
    [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self setHTTPBody:WFHTTPBodyFromQueryItems(queryItems)];
}

@end

NS_ASSUME_NONNULL_END
