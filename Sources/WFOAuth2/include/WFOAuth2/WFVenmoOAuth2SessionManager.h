//
//  WFVenmoOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/7/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_IOS
@class WFVenmoAppAuthorizationSession;
#endif

typedef NSString *WFVenmoOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
extern WFVenmoOAuth2Scope const WFVenmoMakePaymentsScope;
extern WFVenmoOAuth2Scope const WFVenmoPaymentHistoryScope;
extern WFVenmoOAuth2Scope const WFVenmoFeedScope;
extern WFVenmoOAuth2Scope const WFVenmoProfileScope;
extern WFVenmoOAuth2Scope const WFVenmoEmailScope;
extern WFVenmoOAuth2Scope const WFVenmoPhoneScope;
extern WFVenmoOAuth2Scope const WFVenmoBalanceScope;
extern WFVenmoOAuth2Scope const WFVenmoFriendsScope;

@interface WFVenmoOAuth2SessionManager : WFOAuth2SessionManager<WFVenmoOAuth2Scope> <WFOAuth2ProviderSessionManager>

- (WFOAuth2WebAuthorizationSession *)authorizationSessionWithScopes:(nullable NSArray<WFVenmoOAuth2Scope> *)scopes
                                                  completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

#if TARGET_OS_IOS
- (WFVenmoAppAuthorizationSession *)appAuthorizationSessionWithScopes:(nullable NSArray<WFVenmoOAuth2Scope> *)scopes
                                                    completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;
#endif

- (void)authenticateWithScopes:(nullable NSArray<WFVenmoOAuth2Scope> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFVenmoOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
