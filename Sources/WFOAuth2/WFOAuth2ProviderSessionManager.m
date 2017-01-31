//
//  WFOAuth2ProviderSessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>

#import <WFOAuth2/WFOAuth2ProviderSessionManagerSubclass.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2ProviderSessionManager ()

@property (nonatomic, readonly) WFOAuth2SessionManager *internal;

@end

@implementation WFOAuth2ProviderSessionManager

+ (BOOL)basicAuthEnabled {
    return NO;
}

+ (NSURL *)baseURL {
    return nil;
}

+ (NSString *)tokenPath {
    return @"token";
}

+ (NSURL *)authorizationURL {
    return nil;
}

+ (WFOAuth2ResponseType)responseType {
    return WFOAuth2ResponseTypeCode;
}

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil clientID:clientID clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    self = [super init];
    if (!self)
        return nil;
    
    _internal = [[WFOAuth2SessionManager alloc] initWithSessionConfiguration:configuration
                                                                     baseURL:[[self class] baseURL]
                                                            basicAuthEnabled:[[self class] basicAuthEnabled]
                                                                    clientID:clientID
                                                                clientSecret:clientSecret];
    
    return self;
}

- (NSURLSession *)session {
    return self.internal.session;
}

- (NSString *)clientID {
    return self.internal.clientID;
}

- (nullable NSString *)clientSecret {
    return self.internal.clientSecret;
}

- (void)authenticateWithScope:(nullable NSString *)scope
            completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [self.internal authenticateWithPath:[[self class] tokenPath]
                                  scope:scope
                      completionHandler:completionHandler];
}

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [self.internal authenticateWithPath:[[self class] tokenPath]
                               username:username password:password
                                  scope:scope
                      completionHandler:completionHandler];
}

- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [self.internal authenticateWithPath:[[self class] tokenPath]
                                   code:code
                            redirectURI:redirectURI
                      completionHandler:completionHandler];
}

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [self.internal authenticateWithPath:[[self class] tokenPath]
                      refreshCredential:refreshCredential
                      completionHandler:completionHandler];
}

#if __has_include(<WebKit/WebKit.h>)

- (WKWebView *)authorizationWebViewWithScope:(nullable NSString *)scope
                                 redirectURI:(nullable NSURL *)redirectURI
                           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [self.internal authorizationWebViewWithURL:[[self class] authorizationURL]
                                         responseType:[[self class] responseType]
                                                scope:scope
                                          redirectURI:redirectURI
                                            tokenPath:[[self class] tokenPath]
                                    completionHandler:completionHandler];
}

#endif

@end

NS_ASSUME_NONNULL_END
