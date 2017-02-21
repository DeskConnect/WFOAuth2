//
//  WFSquareOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Curtis Thorne on 7/26/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFSquareOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareMerchantProfileReadScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquarePaymentsReadScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquarePaymentsWriteScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareCustomersReadScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareCustomersWriteScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareSettlementsReadScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareBankAccountsReadScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareItemsReadScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareItemsWriteScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareOrdersReadScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareOrdersWriteScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareEmployeesReadScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareEmployeesWriteScope;
WFO_EXTERN WFSquareOAuth2Scope const WFSquareTimecardsWriteScope;

@interface WFSquareOAuth2SessionManager : WFOAuth2SessionManager<WFSquareOAuth2Scope> <WFOAuth2RevocableSessionManager>

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret;

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret;

- (void)authenticateWithScopes:(nullable NSArray<WFSquareOAuth2Scope> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFSquareOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
