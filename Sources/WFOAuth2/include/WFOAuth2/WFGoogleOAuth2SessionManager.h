//
//  WFGoogleOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const WFGoogleNativeRedirectURIString;

typedef NSString *WFGoogleOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
extern WFGoogleOAuth2Scope const WFGoogleOpenIDScope;
extern WFGoogleOAuth2Scope const WFGoogleProfileScope;
extern WFGoogleOAuth2Scope const WFGoogleEmailScope;

@interface WFGoogleOAuth2SessionManager : WFOAuth2SessionManager<WFGoogleOAuth2Scope> <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (WFOAuth2WebAuthorizationSession *)authorizationSessionWithScopes:(nullable NSArray<WFGoogleOAuth2Scope> *)scopes
                                                          loginHint:(nullable NSString *)loginHint
                                                        redirectURI:(nullable NSURL *)redirectURI
                                                  completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

#if __has_include(<WebKit/WebKit.h>)
- (WKWebView *)authorizationWebViewWithScopes:(nullable NSArray<WFGoogleOAuth2Scope> *)scopes
                                    loginHint:(nullable NSString *)loginHint
                                  redirectURI:(nullable NSURL *)redirectURI
                            completionHandler:(WFOAuth2AuthenticationHandler)completionHandler __attribute__((deprecated("Google has deprecated support for OAuth 2.0 authorization in web views", "authorizationSessionWithScopes")));
#endif

- (void)authenticateWithScopes:(nullable NSArray<WFGoogleOAuth2Scope> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFGoogleOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
