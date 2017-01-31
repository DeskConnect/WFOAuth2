//
//  WFUberOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>

#import <WFOAuth2/WFUberOAuth2SessionManager.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const WFUberUserProfileScope = @"profile";
NSString * const WFUberUserHistoryScope = @"history";
NSString * const WFUberUserHistoryLiteScope = @"history_lite";
NSString * const WFUberUserPlacesScope = @"places";
NSString * const WFUberRequestRideScope = @"request";
NSString * const WFUberRequestReceiptScope = @"request_receipt";
NSString * const WFUberAllTripsScope = @"all_trips";

static NSString * const WFUberOAuth2TokenPath = @"token";

@implementation WFUberOAuth2SessionManager

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil clientID:clientID clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    return [super initWithSessionConfiguration:configuration baseURL:[NSURL URLWithString:@"https://login.uber.com/oauth/v2"] basicAuthEnabled:NO clientID:clientID clientSecret:clientSecret];
}

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFUberOAuth2TokenPath username:username password:password scope:scope completionHandler:completionHandler];
}

- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFUberOAuth2TokenPath code:code redirectURI:redirectURI completionHandler:completionHandler];
}

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFUberOAuth2TokenPath refreshCredential:refreshCredential completionHandler:completionHandler];
}

#if __has_include(<WebKit/WebKit.h>)

- (WKWebView *)authorizationWebViewWithScope:(nullable NSString *)scope
                                 redirectURI:(nullable NSURL *)redirectURI
                           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [super authorizationWebViewWithURL:[NSURL URLWithString:@"https://login.uber.com/oauth/v2/authorize"] responseType:WFOAuth2ResponseTypeToken scope:scope redirectURI:redirectURI tokenPath:WFUberOAuth2TokenPath completionHandler:completionHandler];
}

#endif

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID],
                                              [NSURLQueryItem queryItemWithName:@"token" value:credential.accessToken]];
    
    if (self.clientSecret)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"client_secret" value:self.clientSecret]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://login.uber.com/oauth/revoke"]];
    [request setHTTPMethod:@"POST"];
    [request wfo_setBodyWithQueryItems:parameters];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable __unused data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (completionHandler)
            completionHandler([[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode], error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END
