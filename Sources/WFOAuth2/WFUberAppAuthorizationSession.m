//
//  WFUberAppAuthorizationSession.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/7/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFUberAppAuthorizationSession.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFOAuth2Credential.h>
#import <WFOAuth2/NSURL+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

#if TARGET_OS_IOS

NS_ASSUME_NONNULL_BEGIN

@interface WFUberAppAuthorizationSession ()

@property (nonatomic, copy, nullable) WFOAuth2AuthenticationHandler completionHandler;

@end

@implementation WFUberAppAuthorizationSession

- (instancetype)initWithClientID:(NSString *)clientID
                         appName:(NSString *)name
                          scopes:(nullable NSArray<WFUberOAuth2Scope> *)scopes
                     redirectURI:(nullable NSURL *)redirectURI
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(clientID);
    NSParameterAssert(completionHandler);
    self = [super init];
    if (!self)
        return nil;
    
    _redirectURI = [redirectURI copy];
    _completionHandler = completionHandler;

    NSString *scope = [WFUberOAuth2SessionManager combinedScopeFromScopes:scopes];
    
    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray new];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:clientID]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"third_party_app_name" value:name]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"login_type" value:@"default"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"sdk" value:@"ios"]];
    if (redirectURI)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"callback_uri_string" value:redirectURI.absoluteString]];
    if (scope)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"scope" value:scope]];
    
    _authorizationURL = [[NSURL URLWithString:@"uberauth://connect"] wfo_URLByAppendingQueryItems:parameters];
    
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
    
    NSMutableDictionary<NSString *, id> *responseObject = [NSMutableDictionary new];
    for (NSURLQueryItem *item in components.queryItems)
        [responseObject setValue:item.value forKey:item.name];
    
    NSError *error = WFRFC6749Section5_2ErrorFromResponse(responseObject);
    if (error) {
        completionHandler(nil, error);
        return YES;
    }
    
    responseObject[@"expires_in"] = @([responseObject[@"expires_in"] integerValue]);
    
    completionHandler([[WFOAuth2Credential alloc] initWithResponseObject:responseObject], nil);
    return YES;
}

- (BOOL)resumeSessionWithURL:(NSURL *)URL options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([sourceApplication isEqualToString:@"com.ubercab.UberClient"]) {
        return [self resumeSessionWithURL:URL];
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END

#endif
