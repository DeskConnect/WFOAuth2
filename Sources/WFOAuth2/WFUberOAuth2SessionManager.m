//
//  WFUberOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFUberOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFOAuth2Credential.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

WFUberOAuth2Scope const WFUberUserProfileScope = @"profile";
WFUberOAuth2Scope const WFUberUserHistoryScope = @"history";
WFUberOAuth2Scope const WFUberUserHistoryLiteScope = @"history_lite";
WFUberOAuth2Scope const WFUberUserPlacesScope = @"places";
WFUberOAuth2Scope const WFUberRequestRideScope = @"request";
WFUberOAuth2Scope const WFUberRequestReceiptScope = @"request_receipt";
WFUberOAuth2Scope const WFUberAllTripsScope = @"all_trips";

@implementation WFUberOAuth2SessionManager

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
                                     tokenURL:[NSURL URLWithString:@"https://login.uber.com/oauth/v2/mobile/token"]
                             authorizationURL:[NSURL URLWithString:@"https://login.uber.com/oauth/v2/authorize"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID],
                                              [NSURLQueryItem queryItemWithName:@"token" value:credential.accessToken]];
    
    NSString *clientSecret = self.clientSecret;
    if (clientSecret)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"client_secret" value:clientSecret]];
    
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
