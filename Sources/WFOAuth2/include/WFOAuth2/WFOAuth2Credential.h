//
//  WFOAuth2Credential.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 `WFOAuth2Credential` represents an OAuth 2 access token and, optionally, an associated refresh token.
 */
@interface WFOAuth2Credential : NSObject <NSCopying, NSSecureCoding>

/**
 The access token.
 
 @see [Section 1.4](https://tools.ietf.org/html/rfc6749#section-1.4)
 */
@property (nonatomic, readonly, copy) NSString *accessToken;

/**
 The type of access token. This defaults to "bearer".
 
 @see [Section 7.1](https://tools.ietf.org/html/rfc6749#section-7.1)
 */
@property (nonatomic, readonly, copy) NSString *tokenType;

/**
 The refresh token which can be used to refresh the access token.
 
 @see [Section 1.5](https://tools.ietf.org/html/rfc6749#section-1.5)
 */
@property (nonatomic, readonly, copy, nullable) NSString *refreshToken;

/**
 The expiration date of the access token, or `nil` if the access token does not expire.
 */
@property (nonatomic, readonly, copy, nullable) NSDate *expirationDate;

/**
 A token is valid if it either has a refresh token, or the access token is not expired.
 */
@property (nonatomic, readonly, getter = isValid) BOOL valid;

/**
 Whether or not the access token has expired.
 */
@property (nonatomic, readonly, getter = isExpired) BOOL expired;

- (instancetype)init NS_UNAVAILABLE;

/*
 Initializes a credential with the given response object returned from an OAuth 2 token endpoint. Returns `nil` if there is no valid access token in the response object.
 
 @param responseObject The response object returned from an OAuth 2 token endpoint.
 @return A newly created credential object to represent the response object.
 */
- (nullable instancetype)initWithResponseObject:(nullable NSDictionary<NSString *, id<NSCopying>> *)responseObject NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
