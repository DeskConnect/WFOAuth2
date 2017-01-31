//
//  WFSquareOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Curtis Thorne on 7/26/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManagerSubclass.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>

#import <WFOAuth2/WFSquareOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const WFSquareMerchantProfileReadScope = @"MERCHANT_PROFILE_READ";
NSString * const WFSquarePaymentsReadScope = @"PAYMENTS_READ";
NSString * const WFSquarePaymentsWriteScope = @"PAYMENTS_WRITE";
NSString * const WFSquareCustomersReadScope = @"CUSTOMERS_READ";
NSString * const WFSquareCustomersWriteScope = @"CUSTOMERS_WRITE";
NSString * const WFSquareSettlementsReadScope = @"SETTLEMENTS_READ";
NSString * const WFSquareBankAccountsReadScope = @"BANK_ACCOUNTS_READ";
NSString * const WFSquareItemsReadScope = @"ITEMS_READ";
NSString * const WFSquareItemsWriteScope = @"ITEMS_WRITE";
NSString * const WFSquareOrdersReadScope = @"ORDERS_READ";
NSString * const WFSquareOrdersWriteScope = @"ORDERS_WRITE";
NSString * const WFSquareEmployeesReadScope = @"EMPLOYEES_READ";
NSString * const WFSquareEmployeesWriteScope = @"EMPLOYEES_WRITE";
NSString * const WFSquareTimecardsReadScope = @"TIMECARDS_READ";
NSString * const WFSquareTimecardsWriteScope = @"TIMECARDS_WRITE";

@implementation WFSquareOAuth2SessionManager

+ (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://connect.squareup.com/oauth2"];
}

+ (NSURL *)authorizationURL {
    return [NSURL URLWithString:@"https://connect.squareup.com/oauth2/authorize"];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID],
                                              [NSURLQueryItem queryItemWithName:@"access_token" value:credential.accessToken]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://connect.squareup.com/oauth2/revoke"]];
    [request setHTTPMethod:@"POST"];
    
    [request wfo_setBodyWithQueryItems:parameters];
    
    if (self.clientSecret)
        [request setValue:[NSString stringWithFormat:@"Authorization: Client %@", self.clientSecret] forHTTPHeaderField:@"Authorization"];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable __unused data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (completionHandler)
            completionHandler([[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode], error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END
