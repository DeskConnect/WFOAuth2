//
//  WFUberOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_IOS
@class WFUberAppAuthorizationSession;
#endif

typedef NSString *WFUberOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
extern WFUberOAuth2Scope const WFUberUserProfileScope;
extern WFUberOAuth2Scope const WFUberUserHistoryScope;
extern WFUberOAuth2Scope const WFUberUserHistoryLiteScope;
extern WFUberOAuth2Scope const WFUberUserPlacesScope;
extern WFUberOAuth2Scope const WFUberRequestRideScope;
extern WFUberOAuth2Scope const WFUberRequestReceiptScope;
extern WFUberOAuth2Scope const WFUberAllTripsScope;

@interface WFUberOAuth2SessionManager : WFOAuth2SessionManager<WFUberOAuth2Scope> <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret
                                singleSignOn:(BOOL)singleSignOn;

#if TARGET_OS_IOS
- (WFUberAppAuthorizationSession *)appAuthorizationSessionWithAppName:(NSString *)name
                                                               scopes:(nullable NSArray<WFUberOAuth2Scope> *)scopes
                                                          redirectURI:(nullable NSURL *)redirectURI
                                                    completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;
#endif

- (void)authenticateWithScopes:(nullable NSArray<WFUberOAuth2Scope> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFUberOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
