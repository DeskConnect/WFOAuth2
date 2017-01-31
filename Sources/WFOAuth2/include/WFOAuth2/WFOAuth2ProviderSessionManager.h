//
//  WFOAuth2ProviderSessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The `WFOAuth2ProviderSessionManager` protocol is a protocol intended to be adopted by provider-specific subclasses of `WFOAuth2SessionManager` to create a friendly interface.
 
 It removes the `baseURL`, `path` and `authorizationURL` parameters from all public facing methods, because those can be defined in the subclasses.
 */
@interface WFOAuth2ProviderSessionManager: NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret;

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret NS_DESIGNATED_INITIALIZER;

- (void)authenticateWithScope:(nullable NSString *)scope
            completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

#if __has_include(<WebKit/WebKit.h>)
- (WKWebView *)authorizationWebViewWithScope:(nullable NSString *)scope
                                 redirectURI:(nullable NSURL *)redirectURI
                           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;
#endif

@end

NS_ASSUME_NONNULL_END
