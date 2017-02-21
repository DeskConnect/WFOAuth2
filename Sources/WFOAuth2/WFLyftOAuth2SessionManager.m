//
//  WFLyftOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

#import <WFOAuth2/WFLyftOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

WFLyftOAuth2Scope const WFLyftPublicScope = @"public";
WFLyftOAuth2Scope const WFLyftReadRidesScope = @"rides.read";
WFLyftOAuth2Scope const WFLyftRequestRidesScope = @"rides.request";
WFLyftOAuth2Scope const WFLyftProfileScope = @"profile";
WFLyftOAuth2Scope const WFLyftOfflineScope = @"offline";

@implementation WFLyftOAuth2SessionManager

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
                                     tokenURL:[NSURL URLWithString:@"https://api.lyft.com/oauth/token"]
                             authorizationURL:[NSURL URLWithString:@"https://api.lyft.com/oauth/authorize"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretBasicAuth
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSURL *url = [NSURL URLWithString:@"https://api.lyft.com/oauth/revoke_refresh_token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request wfo_setAuthorizationWithUsername:self.clientID password:self.clientSecret];

    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray new];
    if (credential.refreshToken)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"token" value:credential.refreshToken]];
    [request wfo_setBodyWithQueryItems:parameters];

    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (data.length) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            error = (WFRFC6749Section5_2ErrorFromResponse(responseObject) ?: error);
        }
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (completionHandler)
            completionHandler([[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode], error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END
