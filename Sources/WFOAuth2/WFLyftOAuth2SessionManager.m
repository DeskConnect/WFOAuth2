//
//  WFLyftOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFLyftOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>

NSString * const WFLyftPublicScope = @"public";
NSString * const WFLyftReadRidesScope = @"rides.read";
NSString * const WFLyftRequestRidesScope = @"rides.request";
NSString * const WFLyftProfileScope = @"profile";
NSString * const WFLyftOfflineScope = @"offline";

static NSString * const WFLyftOAuth2TokenPath = @"token";

@implementation WFLyftOAuth2SessionManager

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil clientID:clientID clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    return [super initWithSessionConfiguration:configuration baseURL:[NSURL URLWithString:@"https://api.lyft.com/oauth"] basicAuthEnabled:YES clientID:clientID clientSecret:clientSecret];
}

- (void)authenticateWithScope:(nullable NSString *)scope
            completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFLyftOAuth2TokenPath scope:scope completionHandler:completionHandler];
}

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFLyftOAuth2TokenPath username:username password:password scope:scope completionHandler:completionHandler];
}

- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFLyftOAuth2TokenPath code:code redirectURI:redirectURI completionHandler:completionHandler];
}

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFLyftOAuth2TokenPath refreshCredential:refreshCredential completionHandler:completionHandler];
}

#if __has_include(<WebKit/WebKit.h>)

- (WKWebView *)authorizationWebViewWithScope:(nullable NSString *)scope
                                 redirectURI:(nullable NSURL *)redirectURI
                           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [super authorizationWebViewWithURL:[NSURL URLWithString:@"https://api.lyft.com/oauth/authorize"] responseType:WFOAuth2ResponseTypeCode scope:scope redirectURI:redirectURI tokenPath:WFLyftOAuth2TokenPath completionHandler:completionHandler];
}

#endif

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"revoke_refresh_token"];
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
