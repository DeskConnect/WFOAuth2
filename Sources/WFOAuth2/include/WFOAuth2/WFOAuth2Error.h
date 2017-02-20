//
//  WFOAuthError.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFOAuth2/WFOAuth2Defines.h>

NS_ASSUME_NONNULL_BEGIN

WFO_EXTERN NSError * __nullable WFRFC6749Section5_2ErrorFromResponse(NSDictionary * __nullable responseObject);

enum {
    WFOAuth2ErrorUnknown = -1,
    WFOAuth2InvalidRequestError = 100,
    WFOAuth2InvalidClientError = 101,
    WFOAuth2InvalidGrantError = 102,
    WFOAuth2UnauthorizedClientError = 103,
    WFOAuth2UnsupportedGrantTypeError = 104,
    WFOAuth2InvalidScopeError = 105,
    WFOAuth2AccessDeniedError = 106,
    WFOAuth2UnsupportedResponseTypeError = 107,
    WFOAuth2ServerError = 108,
    WFOAuth2TemporarilyUnavailableError = 109,
    WFOAuth2InvalidCallbackError = 200, // Mismatching state, missing code, etc
    WFOAuth2InvalidTokenError = 201, // Google specific extension
    WFOAuth2MismatchingRedirectURIError = 202, // Python OAuthLib specific extension
};
WFO_EXTERN NSString * const WFOAuth2ErrorDomain;

NS_ASSUME_NONNULL_END
