//
//  WFOAuthError.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2Error.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const WFOAuth2ErrorDomain = @"WFOAuth2ErrorDomain";

NSError * __nullable WFRFC6749Section5_2ErrorFromResponse(NSDictionary * __nullable responseObject) {
    NSInteger code = WFOAuth2ErrorUnknown;
    NSString *description = nil;
    
    NSString *errorCode = responseObject[@"error"];
    if (![errorCode isKindOfClass:[NSString class]])
        return nil;
    
    if ([errorCode isEqualToString:@"invalid_request"]) {
        code = WFOAuth2InvalidRequestError;
        description = @"The request is missing a required parameter, includes an unsupported parameter value (other than grant type), repeats a parameter, includes multiple credentials, utilizes more than one mechanism for authenticating the client, or is otherwise malformed.";
    } else if ([errorCode isEqualToString:@"invalid_client"]) {
        code = WFOAuth2InvalidClientError;
        description = @"Client authentication failed (e.g., unknown client, no client authentication included, or unsupported authentication method).  The authorization server MAY return an HTTP 401 (Unauthorized) status code to indicate which HTTP authentication schemes are supported.  If the client attempted to authenticate via the \"Authorization\" request header field, the authorization server MUST respond with an HTTP 401 (Unauthorized) status code and include the \"WWW-Authenticate\" response header field matching the authentication scheme used by the client.";
    } else if ([errorCode isEqualToString:@"invalid_grant"]) {
        code = WFOAuth2InvalidGrantError;
        description = @"The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.";
    } else if ([errorCode isEqualToString:@"unauthorized_client"]) {
        code = WFOAuth2UnauthorizedClientError;
        description = @"The authenticated client is not authorized to use this authorization grant type.";
    } else if ([errorCode isEqualToString:@"unsupported_grant_type"]) {
        code = WFOAuth2UnsupportedGrantTypeError;
        description = @"The authorization grant type is not supported by the authorization server.";
    } else if ([errorCode isEqualToString:@"invalid_scope"]) {
        code = WFOAuth2InvalidScopeError;
        description = @"The requested scope is invalid, unknown, malformed, or exceeds the scope granted by the resource owner.";
    } else if ([errorCode isEqualToString:@"access_denied"]) {
        code = WFOAuth2AccessDeniedError;
        description = @"The resource owner or authorization server denied the request.";
    } else if ([errorCode isEqualToString:@"unsupported_response_type"]) {
        code = WFOAuth2UnsupportedResponseTypeError;
        description = @"The authorization server does not support obtaining an authorization code using this method.";
    } else if ([errorCode isEqualToString:@"server_error"]) {
        code = WFOAuth2ServerError;
        description = @" The authorization server encountered an unexpected condition that prevented it from fulfilling the request.";
    } else if ([errorCode isEqualToString:@"temporarily_unavailable"]) {
        code = WFOAuth2TemporarilyUnavailableError;
        description = @"The authorization server is currently unable to handle the request due to a temporary overloading or maintenance of the server.";
    } else if ([errorCode isEqualToString:@"invalid_token"]) {
        code = WFOAuth2InvalidTokenError;
        description = @"The requested token is invalid, unknown, or malformed.";
    } else if ([errorCode isEqualToString:@"mismatching_redirect_uri"]) {
        code = WFOAuth2MismatchingRedirectURIError;
        description = @"The requested redirect URI does not match any of the client's valid redirect URIs.";
    }
    
    description = (responseObject[@"error_description"] ?: description);
    
    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    [userInfo setValue:description forKey:NSLocalizedDescriptionKey];
    [userInfo setValue:[NSURL URLWithString:responseObject[@"error_uri"]] forKey:NSLocalizedRecoverySuggestionErrorKey];
    
    return [NSError errorWithDomain:WFOAuth2ErrorDomain code:code userInfo:userInfo];
}

NS_ASSUME_NONNULL_END
