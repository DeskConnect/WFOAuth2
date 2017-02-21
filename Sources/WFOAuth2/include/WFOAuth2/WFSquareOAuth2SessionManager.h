//
//  WFSquareOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Curtis Thorne on 7/26/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFSquareOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
extern WFSquareOAuth2Scope const WFSquareMerchantProfileReadScope;
extern WFSquareOAuth2Scope const WFSquarePaymentsReadScope;
extern WFSquareOAuth2Scope const WFSquarePaymentsWriteScope;
extern WFSquareOAuth2Scope const WFSquareCustomersReadScope;
extern WFSquareOAuth2Scope const WFSquareCustomersWriteScope;
extern WFSquareOAuth2Scope const WFSquareSettlementsReadScope;
extern WFSquareOAuth2Scope const WFSquareBankAccountsReadScope;
extern WFSquareOAuth2Scope const WFSquareItemsReadScope;
extern WFSquareOAuth2Scope const WFSquareItemsWriteScope;
extern WFSquareOAuth2Scope const WFSquareOrdersReadScope;
extern WFSquareOAuth2Scope const WFSquareOrdersWriteScope;
extern WFSquareOAuth2Scope const WFSquareEmployeesReadScope;
extern WFSquareOAuth2Scope const WFSquareEmployeesWriteScope;
extern WFSquareOAuth2Scope const WFSquareTimecardsWriteScope;

@interface WFSquareOAuth2SessionManager : WFOAuth2SessionManager<WFSquareOAuth2Scope> <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (void)authenticateWithScopes:(nullable NSArray<WFSquareOAuth2Scope> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFSquareOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
