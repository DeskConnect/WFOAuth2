//
//  WFSquareOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Curtis Thorne on 7/26/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFSquareOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFOAuth2Credential.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

WFSquareOAuth2Scope const WFSquareMerchantProfileReadScope = @"MERCHANT_PROFILE_READ";
WFSquareOAuth2Scope const WFSquarePaymentsReadScope = @"PAYMENTS_READ";
WFSquareOAuth2Scope const WFSquarePaymentsWriteScope = @"PAYMENTS_WRITE";
WFSquareOAuth2Scope const WFSquareCustomersReadScope = @"CUSTOMERS_READ";
WFSquareOAuth2Scope const WFSquareCustomersWriteScope = @"CUSTOMERS_WRITE";
WFSquareOAuth2Scope const WFSquareSettlementsReadScope = @"SETTLEMENTS_READ";
WFSquareOAuth2Scope const WFSquareBankAccountsReadScope = @"BANK_ACCOUNTS_READ";
WFSquareOAuth2Scope const WFSquareItemsReadScope = @"ITEMS_READ";
WFSquareOAuth2Scope const WFSquareItemsWriteScope = @"ITEMS_WRITE";
WFSquareOAuth2Scope const WFSquareOrdersReadScope = @"ORDERS_READ";
WFSquareOAuth2Scope const WFSquareOrdersWriteScope = @"ORDERS_WRITE";
WFSquareOAuth2Scope const WFSquareEmployeesReadScope = @"EMPLOYEES_READ";
WFSquareOAuth2Scope const WFSquareEmployeesWriteScope = @"EMPLOYEES_WRITE";
WFSquareOAuth2Scope const WFSquareTimecardsReadScope = @"TIMECARDS_READ";
WFSquareOAuth2Scope const WFSquareTimecardsWriteScope = @"TIMECARDS_WRITE";

@implementation WFSquareOAuth2SessionManager

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
                                     tokenURL:[NSURL URLWithString:@"https://connect.squareup.com/oauth2/token"]
                             authorizationURL:[NSURL URLWithString:@"https://connect.squareup.com/oauth2/authorize"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID],
                                              [NSURLQueryItem queryItemWithName:@"access_token" value:credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://connect.squareup.com/oauth2/revoke"]];
    [request setHTTPMethod:@"POST"];
    [request wfo_setBodyWithQueryItems:parameters];
    
    NSString *clientSecret = self.clientSecret;
    if (clientSecret)
        [request setValue:[NSString stringWithFormat:@"Authorization: Client %@", clientSecret] forHTTPHeaderField:@"Authorization"];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable __unused data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (completionHandler)
            completionHandler([[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode], error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END
