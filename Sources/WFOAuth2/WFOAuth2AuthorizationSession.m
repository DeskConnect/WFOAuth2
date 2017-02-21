//
//  WFOAuth2AuthorizationSession.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2AuthorizationSessionPrivate.h>
#import <WFOAuth2/NSURL+WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2AuthorizationSession ()

@property (nonatomic, readonly, copy) WFOAuth2SessionManager *sessionManager;
@property (nonatomic, readonly, copy) WFOAuth2ResponseType responseType;
@property (nonatomic, readonly, copy, nullable) NSURL *redirectURI;
@property (nonatomic, readonly, copy) NSString *state;
@property (nonatomic, copy, nullable) WFOAuth2AuthenticationHandler completionHandler;

@end

@implementation WFOAuth2AuthorizationSession

#if TARGET_OS_IOS
@synthesize safariViewController = _safariViewController;
#endif

- (instancetype)initWithSessionManager:(WFOAuth2SessionManager *)sessionManager
                      authorizationURL:(NSURL *)authorizationURL
                          responseType:(WFOAuth2ResponseType)responseType
                           redirectURI:(nullable NSURL *)redirectURI
                     completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(sessionManager);
    NSParameterAssert(authorizationURL);
    NSParameterAssert(responseType);
    NSParameterAssert(completionHandler);
    self = [super init];
    if (!self)
        return nil;
    
    _sessionManager = sessionManager;
    _responseType = [responseType copy];
    _redirectURI = [redirectURI copy];
    _state = [[[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    _completionHandler = completionHandler;
    
    NSDictionary<WFOAuth2ResponseType, NSString *> *mapping = @{WFOAuth2ResponseTypeCode: @"code",
                                                                WFOAuth2ResponseTypeToken: @"access_token"};
    _responseKey = mapping[responseType];
    NSAssert(_responseKey, @"Unknown response type \"%@\"", responseType);

    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray new];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"response_type" value:responseType]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"state" value:_state]];
    if (redirectURI)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:redirectURI.absoluteString]];
    
    _authorizationURL = [authorizationURL wfo_URLByAppendingQueryItems:parameters];
    
    return self;
}

#if TARGET_OS_IOS
- (SFSafariViewController *)safariViewController {
    if (!_safariViewController)
        _safariViewController = [[SFSafariViewController alloc] initWithURL:self.authorizationURL];
    
    return _safariViewController;
}
#endif

- (BOOL)resumeSessionWithResponseObject:(NSDictionary<NSString *, NSString *> *)responseObject {
    WFOAuth2AuthenticationHandler completionHandler = self.completionHandler;
    self.completionHandler = nil;
    if (!completionHandler) {
        return NO;
    }
    
#if TARGET_OS_IOS
    [_safariViewController dismissViewControllerAnimated:YES completion:nil];
#endif
    
    NSError *error = WFRFC6749Section5_2ErrorFromResponse(responseObject);
    if (error) {
        completionHandler(nil, error);
        return YES;
    }
    
    NSString *state = self.state;
    if (state.length && ![responseObject[@"state"] isEqualToString:state]) {
        completionHandler(nil, [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2InvalidCallbackError userInfo:@{NSLocalizedDescriptionKey: @"The state parameter on the received callback was invalid."}]);
        return YES;
    }
    
    NSString *responseKey = self.responseKey;
    NSString *value = responseObject[responseKey];
    if (!value.length) {
        completionHandler(nil, [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2InvalidCallbackError userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat: @"The \"%@\" parameter on the received callback was missing.", responseKey]}]);
        return YES;
    }
    
    WFOAuth2ResponseType responseType = self.responseType;
    if ([responseType isEqualToString:WFOAuth2ResponseTypeCode]) {
        [self.sessionManager authenticateWithCode:value redirectURI:self.redirectURI completionHandler:completionHandler];
    } else if ([responseType isEqualToString:WFOAuth2ResponseTypeToken]) {
        NSError *error = WFRFC6749Section5_2ErrorFromResponse(responseObject);
        WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];
        completionHandler(credential, error);
    }
    
    return YES;
}

- (BOOL)resumeSessionWithURL:(NSURL *)URL {
    NSURL *redirectURI = self.redirectURI;
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSURLComponents *redirectComponents = (redirectURI ? [NSURLComponents componentsWithURL:redirectURI resolvingAgainstBaseURL:NO] : nil);
    
    NSMutableDictionary<NSString *, NSString *> *responseObject = [NSMutableDictionary new];
    for (NSURLQueryItem *item in components.queryItems)
        [responseObject setValue:item.value forKey:item.name];
    
    NSURLComponents *fragmentComponents = [NSURLComponents new];
    fragmentComponents.percentEncodedQuery = components.fragment;
    for (NSURLQueryItem *item in fragmentComponents.queryItems)
        [responseObject setValue:item.value forKey:item.name];
    
    [components setQuery:nil];
    [components setFragment:nil];
    if ([components.path hasSuffix:@"/"])
        components.path = [components.path substringToIndex:(components.path.length - 1)];
    
    [redirectComponents setQuery:nil];
    [redirectComponents setFragment:nil];
    if ([redirectComponents.path hasSuffix:@"/"])
        redirectComponents.path = [redirectComponents.path substringToIndex:(redirectComponents.path.length - 1)];
    
    if (redirectURI) {
        // Uber redirects errors to a different endpoint
        if (![components isEqual:redirectComponents] && !responseObject[@"error"])
            return NO;
        
        return [self resumeSessionWithResponseObject:responseObject];
    } else {
        if ((responseObject[self.responseKey] && responseObject[@"state"]) || responseObject[@"error"]) {
            return [self resumeSessionWithResponseObject:responseObject];
        }
        return NO;
    }
}

#if TARGET_OS_IOS
- (BOOL)resumeSessionWithURL:(NSURL *)URL options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([sourceApplication isEqualToString:@"com.apple.SafariViewService"] ||
        [sourceApplication isEqualToString:@"com.apple.mobilesafari"]) {
        return [self resumeSessionWithURL:URL];
    }
    
    return NO;
}
#endif

@end

NS_ASSUME_NONNULL_END
