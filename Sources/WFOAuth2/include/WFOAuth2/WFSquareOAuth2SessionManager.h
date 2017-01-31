//
//  WFSquareOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Curtis Thorne on 7/26/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>
#import <WFOAuth2/WFOAuth2Defines.h>

NS_ASSUME_NONNULL_BEGIN

WF_EXTERN NSString * const WFSquareMerchantProfileReadScope;
WF_EXTERN NSString * const WFSquarePaymentsReadScope;
WF_EXTERN NSString * const WFSquarePaymentsWriteScope;
WF_EXTERN NSString * const WFSquareCustomersReadScope;
WF_EXTERN NSString * const WFSquareCustomersWriteScope;
WF_EXTERN NSString * const WFSquareSettlementsReadScope;
WF_EXTERN NSString * const WFSquareBankAccountsReadScope;
WF_EXTERN NSString * const WFSquareItemsReadScope;
WF_EXTERN NSString * const WFSquareItemsWriteScope;
WF_EXTERN NSString * const WFSquareOrdersReadScope;
WF_EXTERN NSString * const WFSquareOrdersWriteScope;
WF_EXTERN NSString * const WFSquareEmployeesReadScope;
WF_EXTERN NSString * const WFSquareEmployeesWriteScope;
WF_EXTERN NSString * const WFSquareTimecardsWriteScope;


@interface WFSquareOAuth2SessionManager : WFOAuth2SessionManager <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (void)authenticateWithScope:(nullable NSString *)scope
            completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
