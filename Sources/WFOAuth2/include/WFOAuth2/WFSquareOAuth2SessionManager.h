//
//  WFSquareOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Curtis Thorne on 7/26/16.
//  Copyright © 2016 Conrad Kramer. All rights reserved.
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

- (instancetype)initWithClientID:(NSString *)clientID clientSecret:(nullable NSString *)clientSecret;

@end

NS_ASSUME_NONNULL_END
