//
//  NSMutableURLRequest+WFOAuth2.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2Credential.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableURLRequest (WFOAuth2)

/**
 Sets the authorization header of the request with the access token of the provided credential.
 
 @param credential The credential configure on the request. The token must be a bearer token.
 */
- (void)wfo_setAuthorizationWithCredential:(nullable WFOAuth2Credential *)credential;

/**
 Sets the authorization header of the request with the provider username and password.
 
 @param username The username to set in the authorization header.
 @param password The password to set in the authorization header.
 */
- (void)wfo_setAuthorizationWithUsername:(NSString *)username password:(nullable NSString *)password;

/**
 Sets the body of the request with the provided query items using form encoding. This method
 also sets the Content-Type header to @"application/x-www-form-urlencoded"
 
 @param queryItems The query items to set in the body of the request.
 */
- (void)wfo_setBodyWithQueryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems;
                                                                                            
@end

NS_ASSUME_NONNULL_END
