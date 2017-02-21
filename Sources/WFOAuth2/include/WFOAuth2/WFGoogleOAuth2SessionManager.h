//
//  WFGoogleOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

WFO_EXTERN NSString * const WFGoogleNativeRedirectURIString;

typedef NSString *WFGoogleOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
WFO_EXTERN WFGoogleOAuth2Scope const WFGoogleEmailScope;
WFO_EXTERN WFGoogleOAuth2Scope const WFGoogleProfileScope;

@interface WFGoogleOAuth2SessionManager : WFOAuth2SessionManager<WFGoogleOAuth2Scope> <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (void)authenticateWithScopes:(nullable NSArray<WFGoogleOAuth2Scope> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFGoogleOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
