//
//  WFBoxAppAuthorizationSession.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/11/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFBoxAppAuthorizationSession.h>
#import <WFOAuth2/NSURL+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

#if TARGET_OS_IOS

NS_ASSUME_NONNULL_BEGIN

@interface WFBoxAppAuthorizationSession ()

@property (nonatomic, readonly) WFBoxOAuth2SessionManager *sessionManager;
@property (nonatomic, readonly) NSString *state;
@property (nonatomic, copy, nullable) WFOAuth2AuthenticationHandler completionHandler;

@end

@implementation WFBoxAppAuthorizationSession

- (instancetype)initWithSessionManager:(WFBoxOAuth2SessionManager *)sessionManager
                               appName:(NSString *)name
                           redirectURI:(nullable NSURL *)redirectURI
                     completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(sessionManager);
    NSParameterAssert(completionHandler);
    self = [super init];
    if (!self)
        return nil;
    
    _sessionManager = sessionManager;
    _state = [[[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    _redirectURI = [redirectURI copy];
    _completionHandler = completionHandler;

    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray new];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"BoxApplicationName" value:name]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"BoxMessageAction" value:@"login"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:sessionManager.clientID]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"state" value:_state]];
    if (redirectURI) {
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"BoxMessageReturnURLScheme" value:redirectURI.scheme]];
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:redirectURI.absoluteString]];
    }

    _authorizationURL = [[NSURL URLWithString:@"box-onecloud://"] wfo_URLByAppendingQueryItems:parameters];
    
    return self;
}

#pragma mark - WFOAuth2AuthorizationSession

- (BOOL)resumeSessionWithURL:(NSURL *)URL {
    WFOAuth2AuthenticationHandler completionHandler = self.completionHandler;
    NSURL *redirectURI = self.redirectURI;
    if (!completionHandler || ![URL wfo_isEqualToRedirectURI:redirectURI]) {
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
    
    [self.sessionManager authenticateWithCode:code redirectURI:redirectURI completionHandler:completionHandler];
    return YES;
}

- (BOOL)resumeSessionWithURL:(NSURL *)URL options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([sourceApplication isEqualToString:@"net.box.BoxNet"]) {
        return [self resumeSessionWithURL:URL];
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END

#endif
