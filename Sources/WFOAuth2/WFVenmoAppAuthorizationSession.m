//
//  WFVenmoAppAuthorizationSession.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/7/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFVenmoAppAuthorizationSession.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/NSURL+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

#if TARGET_OS_IOS

NS_ASSUME_NONNULL_BEGIN

@interface WFVenmoAppAuthorizationSession ()

@property (nonatomic, readonly) WFVenmoOAuth2SessionManager *sessionManager;
@property (nonatomic, copy, nullable) WFOAuth2AuthenticationHandler completionHandler;

@end

@implementation WFVenmoAppAuthorizationSession

- (instancetype)initWithSessionManager:(WFVenmoOAuth2SessionManager *)sessionManager
                                scopes:(nullable NSArray<WFVenmoOAuth2Scope> *)scopes
                     completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(sessionManager);
    NSParameterAssert(completionHandler);
    self = [super init];
    if (!self)
        return nil;
    
    _sessionManager = sessionManager;
    _redirectURI = [NSURL URLWithString:[NSString stringWithFormat:@"venmo%@://oauth", sessionManager.clientID]];
    _completionHandler = completionHandler;

    NSString *scope = [WFVenmoOAuth2SessionManager combinedScopeFromScopes:scopes];
    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray new];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:sessionManager.clientID]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"response_type" value:@"code"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"sdk" value:@"ios"]];
    if (scope)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"scope" value:scope]];
    
    _authorizationURL = [[NSURL URLWithString:@"venmo://oauth/authorize"] wfo_URLByAppendingQueryItems:parameters];
    
    return self;
}

#pragma mark - WFOAuth2AuthorizationSession

- (BOOL)resumeSessionWithURL:(NSURL *)URL {
    WFOAuth2AuthenticationHandler completionHandler = self.completionHandler;
    if (!completionHandler || ![URL wfo_isEqualToRedirectURI:self.redirectURI]) {
        return NO;
    }
    
    self.completionHandler = nil;
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    
    NSMutableDictionary<NSString *, NSString *> *responseObject = [NSMutableDictionary new];
    for (NSURLQueryItem *item in components.queryItems)
        [responseObject setValue:item.value forKey:item.name];
    
    NSError *error = WFRFC6749Section5_2ErrorFromResponse(responseObject);
    if (error) {
        completionHandler(nil, error);
        return YES;
    }
    
    NSString *code = responseObject[@"code"];
    if (!code.length) {
        completionHandler(nil, [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2InvalidCallbackError userInfo:@{NSLocalizedDescriptionKey: @"The \"code\" parameter on the received callback was missing."}]);
        return YES;
    }
    
    [self.sessionManager authenticateWithCode:code redirectURI:nil completionHandler:completionHandler];
    return YES;
}

- (BOOL)resumeSessionWithURL:(NSURL *)URL options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([sourceApplication isEqualToString:@"net.kortina.labs.Venmo"]) {
        return [self resumeSessionWithURL:URL];
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END

#endif
