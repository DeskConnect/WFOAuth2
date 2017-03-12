//
//  WFOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<WebKit/WebKit.h>)
#import <WebKit/WebKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class WFOAuth2Credential;
@class WFOAuth2WebAuthorizationSession;

typedef NSString *WFOAuth2ResponseType NS_STRING_ENUM;
extern WFOAuth2ResponseType const WFOAuth2ResponseTypeCode;
extern WFOAuth2ResponseType const WFOAuth2ResponseTypeToken;

typedef NSString *WFOAuth2AuthMethod NS_EXTENSIBLE_STRING_ENUM;
extern WFOAuth2AuthMethod const WFOAuth2AuthMethodClientSecretPostBody;
extern WFOAuth2AuthMethod const WFOAuth2AuthMethodClientSecretBasicAuth;

/**
 A block object to be executed when a token request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 */
typedef void (^WFOAuth2AuthenticationHandler)(WFOAuth2Credential * __nullable credential, NSError * __nullable error);

/**
 `WFOAuth2SessionManager` creates and manages an `NSURLSession` object for the purpose of authorizing with a service that conforms to the [OAuth 2.0](https://tools.ietf.org/html/rfc6749) spec.
 
 @see [RFC 6749](https://tools.ietf.org/html/rfc6749)
 */
@interface WFOAuth2SessionManager<ScopeType: NSString *> : NSObject

/**
 The URL of the token endpoint where all authentication requests are sent.
 */
@property (nonatomic, readonly, nullable, copy) NSURL *tokenURL;

/**
 The URL of the authorization endpoint which is displayed to the user.
 */
@property (nonatomic, readonly, nullable, copy) NSURL *authorizationURL;

/**
 The client ID of the application.
 
 @see [Section 2.2](https://tools.ietf.org/html/rfc6749#section-2.2)
 */
@property (nonatomic, readonly, copy) NSString *clientID;

/**
 The client secret of the application. The client secret is optional for some providers.
 
 @see [Section 2.3](https://tools.ietf.org/html/rfc6749#section-2.3)
 */
@property (nonatomic, readonly, copy, nullable) NSString *clientSecret;

/**
 Which method to use to authenticate with the server.
 
 @see [Section 2.3](https://tools.ietf.org/html/rfc6749#section-2.3)
 */
@property (nonatomic, readonly) WFOAuth2AuthMethod authenticationMethod;

- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes a manager for a session created with the specified configuration. This is the designated initializer.
 
 @param configuration The session configuration to create the session with. If `nil`, the default configuration is used.
 @param tokenURL The URL of the token endpoint.
 @param authorizationURL The URL of the authorization endpoint.
 @param authenticationMethod Which method to use to authenticate with the server.
 @param clientID The client ID to use for all requests.
 @param baseURL The client secret to use for for token requests.
 @return A manager for a newly-created session.
 */
- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    tokenURL:(nullable NSURL *)tokenURL
                            authorizationURL:(nullable NSURL *)authorizationURL
                        authenticationMethod:(WFOAuth2AuthMethod)authenticationMethod
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret NS_DESIGNATED_INITIALIZER;

/**
 Authenticates with the provider using a client credentials credentials grant. Most OAuth 2 providers do not support this grant type.
 
 @param scope The desired scope of the requested grant as defined in [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3) of the OAuth 2 spec.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @see [Section 4.4](https://tools.ietf.org/html/rfc6749#section-4.3)
 */
- (void)authenticateWithScopes:(nullable NSArray<ScopeType> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

/**
 Authenticates with the provider using a password credentials grant with the specified username and password. Most OAuth 2 providers do not support this grant type.
 
 @param username The username of the user requesting the grant.
 @param password The password to the user requesting the grant.
 @param scope The desired scope of the requested grant as defined in [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3) of the OAuth 2 spec.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @see [Section 4.3](https://tools.ietf.org/html/rfc6749#section-4.3)
 */
- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<ScopeType> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

/**
 Exchanges the specified authorization code with the provider to receive an authorization code grant. The code is received by completing an authorization request prior. Most OAuth 2 providers support this grant type.
 
 @param code The code to exchange for the grant.
 @param redirectURI The redirect URI used to receive the code as defined in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2) of the OAuth 2 spec.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @see [Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1)
 */
- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

/**
 Refreshes the specified credential to receive a refresh token grant. OAuth 2 providers with refresh tokens support this grant type.
 
 @param refreshCredential The credential to refresh.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @warning The credential given to this method must have a refresh token
 @see [Section 6](https://tools.ietf.org/html/rfc6749#section-6)
 */
- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

/**
 Creates an authorization request to receive an authorization code.
 
 @param responseType The response type to receive as defined in [Section 3.1.1](https://tools.ietf.org/html/rfc6749#section-3.1.1) of the OAuth 2 spec.
 @param scope The desired scope of the grant as defined in [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3) of the OAuth 2 spec.
 @param redirectURI The redirect URI to use to receive the result as defined in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2) of the OAuth 2 spec.
 @param state The state parameter to use to unique the authorization code in order to prevent CSRF attacks as defined in [Section 4.1.1](https://tools.ietf.org/html/rfc6749#section-4.1.1) of the OAuth 2 spec.
 @return A URL request containing all of the specified parameters
 @see [Section 4.1.1](https://tools.ietf.org/html/rfc6749#section-4.1.1)
 */
- (WFOAuth2WebAuthorizationSession *)authorizationSessionWithResponseType:(WFOAuth2ResponseType)responseType
                                                                   scopes:(nullable NSArray<ScopeType> *)scopes
                                                              redirectURI:(nullable NSURL *)redirectURI
                                                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

#if __has_include(<WebKit/WebKit.h>)
/**
 Creates a web view to authorize and authenticate with a provider using an authorization code grant. The web view is preloaded with the authorization request and handles everything automatically.
 
 @param responseType The response type to receive as defined in [Section 3.1.1](https://tools.ietf.org/html/rfc6749#section-3.1.1) of the OAuth 2 spec.
 @param scope The desired scope of the code as defined in [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3) of the OAuth 2 spec.
 @param redirectURI The redirect URI to use to receive the code as defined in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2) of the OAuth 2 spec.
 @param tokenPath The relative path of the token endpoint.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @return A web view that the user can use to authorize with the provider.
 @see [Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1)
 */
- (WKWebView *)authorizationWebViewWithResponseType:(WFOAuth2ResponseType)responseType
                                             scopes:(nullable NSArray<ScopeType> *)scopes
                                        redirectURI:(nullable NSURL *)redirectURI
                                  completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;
#endif

@end

NS_ASSUME_NONNULL_END
