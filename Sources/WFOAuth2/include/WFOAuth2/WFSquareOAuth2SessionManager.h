//
//  WFSquareOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Curtis Thorne on 7/26/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>
#import <WFOAuth2/WFOAuth2Defines.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFSquareOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
WF_EXTERN WFSquareOAuth2Scope const WFSquareMerchantProfileReadScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquarePaymentsReadScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquarePaymentsWriteScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareCustomersReadScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareCustomersWriteScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareSettlementsReadScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareBankAccountsReadScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareItemsReadScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareItemsWriteScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareOrdersReadScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareOrdersWriteScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareEmployeesReadScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareEmployeesWriteScope;
WF_EXTERN WFSquareOAuth2Scope const WFSquareTimecardsWriteScope;

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
