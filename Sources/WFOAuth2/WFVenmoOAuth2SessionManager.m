//
//  WFVenmoOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/7/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFVenmoOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFVenmoAppAuthorizationSession.h>

NS_ASSUME_NONNULL_BEGIN

WFVenmoOAuth2Scope const WFVenmoMakePaymentsScope = @"make_payments";
WFVenmoOAuth2Scope const WFVenmoPaymentHistoryScope = @"access_payment_history";
WFVenmoOAuth2Scope const WFVenmoFeedScope = @"access_feed";
WFVenmoOAuth2Scope const WFVenmoProfileScope = @"access_profile";
WFVenmoOAuth2Scope const WFVenmoEmailScope = @"access_email";
WFVenmoOAuth2Scope const WFVenmoPhoneScope = @"access_phone";
WFVenmoOAuth2Scope const WFVenmoBalanceScope = @"access_balance";
WFVenmoOAuth2Scope const WFVenmoFriendsScope = @"access_friends";

@implementation WFVenmoOAuth2SessionManager

- (WFOAuth2WebAuthorizationSession *)authorizationSessionWithScopes:(nullable NSArray<WFVenmoOAuth2Scope> *)scopes
                                                  completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSURL *redirectURI = [NSURL URLWithString:[NSString stringWithFormat:@"venmo%@://oauth", self.clientID]];
    return [super authorizationSessionWithAuthorizationURL:self.authorizationURL
                                              responseType:WFOAuth2ResponseTypeCode
                                                    scopes:scopes
                                               redirectURI:redirectURI
                                        specifyRedirectURI:NO
                                         completionHandler:completionHandler];
}

#if TARGET_OS_IOS
- (WFVenmoAppAuthorizationSession *)appAuthorizationSessionWithScopes:(nullable NSArray<WFVenmoOAuth2Scope> *)scopes
                                                    completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [[WFVenmoAppAuthorizationSession alloc] initWithSessionManager:self scopes:scopes completionHandler:completionHandler];
}
#endif

#pragma mark - WFOAuth2ProviderSessionManager

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:configuration
                                     tokenURL:[NSURL URLWithString:@"https://api.venmo.com/v1/oauth/access_token"]
                             authorizationURL:[NSURL URLWithString:@"https://api.venmo.com/v1/oauth/authorize?sdk=ios"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

@end

NS_ASSUME_NONNULL_END
