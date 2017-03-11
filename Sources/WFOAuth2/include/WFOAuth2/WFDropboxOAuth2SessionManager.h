//
//  WFDropboxOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@class WFDropboxAppAuthorizationSession;

@interface WFDropboxOAuth2SessionManager : WFOAuth2SessionManager <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (WFOAuth2WebAuthorizationSession *)authorizationSessionWithCompletionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

#if TARGET_OS_IOS
- (WFDropboxAppAuthorizationSession *)appAuthorizationSessionWithCompletionHandler:(WFOAuth2AuthenticationHandler)completionHandler;
#endif

#if __has_include(<WebKit/WebKit.h>)
- (WKWebView *)authorizationWebViewWithRedirectURI:(nullable NSURL *)redirectURI
                                 completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;
#endif

- (void)authenticateWithLegacyAccessToken:(NSString *)accessToken
                        accessTokenSecret:(NSString *)accessTokenSecret
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

- (void)authenticateWithScopes:(nullable NSArray<NSString *> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<NSString *> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
