//
//  WFOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#if __has_include(<WebKit/WebKit.h>)
#import <WebKit/WebKit.h>
#endif

#import <WFOAuth2/WFOAuth2Credential.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFOAuth2ResponseType NS_EXTENSIBLE_STRING_ENUM;
extern WFOAuth2ResponseType const WFOAuth2ResponseTypeCode;
extern WFOAuth2ResponseType const WFOAuth2ResponseTypeToken;

/**
  A block object to be executed when a token request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 */
typedef void (^WFOAuth2AuthenticationHandler)(WFOAuth2Credential * __nullable credential, NSError * __nullable error);

/**
 `WFOAuth2SessionManager` creates and manages an `NSURLSession` object for the purpose of authorizing with a service that conforms to the [OAuth2 spec](https://tools.ietf.org/html/rfc6749).
 
 ## Subclassing Notes

 `WFOAuth2SessionManager` is intended to be configurable such that it doesn't require subclassing.
 
 Subclassing is recommended for the following use cases:
 
 - When building a convenience class for authenticating with a specific provider. This subclass should adhere to the `WFOAuth2ProviderSessionManager` protocol if it builds in provider specific behavior.
 - When handling strong deviations from the OAuth 2 spec.
 
 @see [RFC6749](https://tools.ietf.org/html/rfc6749)
 */
@interface WFOAuth2SessionManager : NSObject

/**
 The base URL onto which all relative paths are appended.
 */
@property (nonatomic, readonly, copy) NSURL *baseURL;

/**
 The client ID of the application.
 
 @see [Section 2.2](https://tools.ietf.org/html/rfc6749#section-2.2)
 */
@property (nonatomic, readonly, copy) NSString *clientID;

/**
 The client secret of the application. The client secret is optional for some providers.
 
 @see [Section 2.3.1](https://tools.ietf.org/html/rfc6749#section-2.3.1)
 */
@property (nonatomic, readonly, copy, nullable) NSString *clientSecret;

/**
 Whether or not to place the client ID and client secret in the `Authorization` header as basic authentication.
 
 @see [Section 2.3.1](https://tools.ietf.org/html/rfc6749#section-2.3.1)
 */
@property (nonatomic, readonly, getter=isBasicAuthEnabled) BOOL basicAuthEnabled;

- (instancetype)init NS_UNAVAILABLE;

/**
 Initializes a manager for a session with the default configuration.
 
 @param baseURL The base URL to use for all requests.
 @param clientID The client ID to use for all requests.
 @param baseURL The client secret to use for for token requests.
 @return A manager for a newly-created session.
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL
                       clientID:(NSString *)clientID
                   clientSecret:(nullable NSString *)clientSecret;

/**
 Initializes a manager for a session created with the specified configuration. This is the designated initializer.
 
 @param configuration The session configuration to create the session with. If `nil`, the default configuration is used.
 @param baseURL The base URL to use for all requests.
 @param basicAuthEnabled Whether or not to use basic auth in the token requests.
 @param clientID The client ID to use for all requests.
 @param baseURL The client secret to use for for token requests.
 @return A manager for a newly-created session.
 */
- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                     baseURL:(NSURL *)baseURL
                            basicAuthEnabled:(BOOL)basicAuthEnabled
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret NS_DESIGNATED_INITIALIZER;

/**
 Authenticates with the provider using a password credentials grant with the specified username and password. Most OAuth 2 providers do not support this grant type.
 
 @param path The relative path of the token endpoint.
 @param username The username of the user requesting the grant.
 @param password The password to the user requesting the grant.
 @param scope The desired scope of the requested grant as defined in [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3) of the OAuth 2 spec.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @see [Section 4.3](https://tools.ietf.org/html/rfc6749#section-4.3)
 */
- (void)authenticateWithPath:(NSString *)path
                    username:(NSString *)username
                    password:(NSString *)password
                       scope:(nullable NSString *)scope
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

/**
 Exchanges the specified authorization code with the provider to receive an authorization code grant. The code is received by completing an authorization request prior. Most OAuth 2 providers support this grant type.
 
 @param path The relative path of the token endpoint.
 @param code The code to exchange for the grant.
 @param redirectURI The redirect URI used to receive the code as defined in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2) of the OAuth 2 spec.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @see [Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1)
 */
- (void)authenticateWithPath:(NSString *)path
                        code:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

/**
 Refreshes the specified credential to receive a refresh token grant. OAuth 2 providers with refresh tokens support this grant type.
 
 @param path The relative path of the token endpoint.
 @param refreshCredential The credential to refresh.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @warning The credential given to this method must have a refresh token
 @see [Section 6](https://tools.ietf.org/html/rfc6749#section-6)
 */
- (void)authenticateWithPath:(NSString *)path
           refreshCredential:(WFOAuth2Credential *)refreshCredential
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;


/**
 Creates an authorization request to receive an authorization code.
 
 @param authorizationURL The full URL of the authorization endpoint. This can have a different base URL than the token endpoint.
 @param responseType The response type to receive as defined in [Section 3.1.1](https://tools.ietf.org/html/rfc6749#section-3.1.1) of the OAuth 2 spec.
 @param scope The desired scope of the grant as defined in [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3) of the OAuth 2 spec.
 @param redirectURI The redirect URI to use to receive the result as defined in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2) of the OAuth 2 spec.
 @param state The state parameter to use to unique the authorization code in order to prevent CSRF attacks as defined in [Section 4.1.1](https://tools.ietf.org/html/rfc6749#section-4.1.1) of the OAuth 2 spec.
 @return A URL request containing all of the specified parameters
 @see [Section 4.1.1](https://tools.ietf.org/html/rfc6749#section-4.1.1)
 */
- (NSURLRequest *)authorizationRequestWithURL:(NSURL *)authorizationURL
                                 responseType:(WFOAuth2ResponseType)responseType
                                        scope:(nullable NSString *)scope
                                  redirectURI:(nullable NSURL *)redirectURI
                                        state:(nullable NSString *)state;

#if __has_include(<WebKit/WebKit.h>)
/**
 Creates a web view to authorize and authenticate with a provider using an authorization code grant. The web view is preloaded with the authorization request and handles everything automatically.
 
 @param authorizationURL The full URL of the authorization endpoint. This can have a different base URL than the token endpoint.
 @param scope The desired scope of the code as defined in [Section 3.3](https://tools.ietf.org/html/rfc6749#section-3.3) of the OAuth 2 spec.
 @param redirectURI The redirect URI to use to receive the code as defined in [Section 3.1.2](https://tools.ietf.org/html/rfc6749#section-3.1.2) of the OAuth 2 spec.
 @param tokenPath The relative path of the token endpoint.
 @param completionHandler A block object to be executed when the request finishes. This block has no return value and takes two arguments: the credential if the request succeeds, and the error that occurred, if any.
 @return A web view that the user can use to authorize with the provider.
 @see [Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1)
 */
- (WKWebView *)authorizationWebViewWithURL:(NSURL *)authorizationURL
                                     scope:(nullable NSString *)scope
                               redirectURI:(nullable NSURL *)redirectURI
                                 tokenPath:(NSString *)tokenPath
                         completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;
#endif

@end

NS_ASSUME_NONNULL_END
