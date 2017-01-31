//
//  WFSquareOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Curtis Thorne on 7/26/16.
//  Copyright © 2016 Conrad Kramer. All rights reserved.
//
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>

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

static NSString * const WFSquareOAuth2TokenPath = @"token";

@implementation WFSquareOAuth2SessionManager

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil clientID:clientID clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    return [super initWithSessionConfiguration:configuration baseURL:[NSURL URLWithString:@"https://connect.squareup.com/oauth2"] basicAuthEnabled:NO clientID:clientID clientSecret:clientSecret];
}

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFSquareOAuth2TokenPath username:username password:password scope:scope completionHandler:completionHandler];
}

- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFSquareOAuth2TokenPath code:code redirectURI:redirectURI completionHandler:completionHandler];
}

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFSquareOAuth2TokenPath refreshCredential:refreshCredential completionHandler:completionHandler];
}

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

#if __has_include(<WebKit/WebKit.h>)

- (WKWebView *)authorizationWebViewWithScope:(nullable NSString *)scope
                                 redirectURI:(nullable NSURL *)redirectURI
                           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [super authorizationWebViewWithURL:[NSURL URLWithString:@"https://connect.squareup.com/oauth2/authorize"] responseType:WFOAuth2ResponseTypeCode scope:scope redirectURI:redirectURI tokenPath:WFSquareOAuth2TokenPath completionHandler:completionHandler];
}

#endif

@end

NS_ASSUME_NONNULL_END
