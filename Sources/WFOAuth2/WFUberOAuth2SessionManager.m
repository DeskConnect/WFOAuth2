//
//  WFUberOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManagerSubclass.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>

#import <WFOAuth2/WFUberOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const WFUberUserProfileScope = @"profile";
NSString * const WFUberUserHistoryScope = @"history";
NSString * const WFUberUserHistoryLiteScope = @"history_lite";
NSString * const WFUberUserPlacesScope = @"places";
NSString * const WFUberRequestRideScope = @"request";
NSString * const WFUberRequestReceiptScope = @"request_receipt";
NSString * const WFUberAllTripsScope = @"all_trips";

@implementation WFUberOAuth2SessionManager

+ (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://login.uber.com/oauth/v2/mobile"];
}

+ (NSURL *)authorizationURL {
    return [NSURL URLWithString:@"https://login.uber.com/oauth/v2/authorize"];
}

+ (WFOAuth2ResponseType)responseType {
    return WFOAuth2ResponseTypeToken;
}

#pragma mark - WFOAuth2RevocableSessionManager

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
