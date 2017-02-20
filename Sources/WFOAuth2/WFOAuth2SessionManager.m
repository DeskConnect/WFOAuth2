//
//  WFOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFOAuth2AuthorizationSessionPrivate.h>
#import <WFOAuth2/WFOAuth2WebView.h>
#import <WFOAuth2/WFOAuth2Error.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/NSURL+WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFOAuth2GrantType NS_EXTENSIBLE_STRING_ENUM;
static WFOAuth2GrantType const WFOAuth2GrantTypeResourceOwnerPasswordCredentials = @"password";
static WFOAuth2GrantType const WFOAuth2GrantTypeClientCredentials = @"client_credentials";
static WFOAuth2GrantType const WFOAuth2GrantTypeAuthorizationCode = @"authorization_code";
static WFOAuth2GrantType const WFOAuth2GrantTypeRefreshToken = @"refresh_token";

WFOAuth2ResponseType const WFOAuth2ResponseTypeCode = @"code";
WFOAuth2ResponseType const WFOAuth2ResponseTypeToken = @"token";

WFOAuth2AuthMethod const WFOAuth2AuthMethodClientSecretPostBody = @"client_secret_post";
WFOAuth2AuthMethod const WFOAuth2AuthMethodClientSecretBasicAuth = @"client_secret_basic";

@implementation WFOAuth2SessionManager

+ (nullable NSString *)combinedScopeFromScopes:(nullable NSArray<NSString *> *)scopes {
    return [scopes componentsJoinedByString:@" "];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    tokenURL:(nullable NSURL *)tokenURL
                            authorizationURL:(nullable NSURL *)authorizationURL
                        authenticationMethod:(WFOAuth2AuthMethod)authenticationMethod
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    NSParameterAssert(authenticationMethod);
    NSParameterAssert(clientID);
    self = [super init];
    if (!self)
        return nil;
    
    _session = [NSURLSession sessionWithConfiguration:(configuration ?: [NSURLSessionConfiguration defaultSessionConfiguration])];
    _tokenURL = [tokenURL copy];
    _authorizationURL = [authorizationURL copy];
    _authenticationMethod = [authenticationMethod copy];
    _clientID = [clientID copy];
    _clientSecret = [clientSecret copy];
    
    return self;
}

- (void)authenticateWithScopes:(nullable NSArray<NSString *> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"grant_type" value:WFOAuth2GrantTypeClientCredentials]];
    
    NSString *scope = [[self class] combinedScopeFromScopes:scopes];
    if (scope)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"scope" value:scope]];
    
    [self authenticateWithParameters:parameters completionHandler:completionHandler];
}

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<NSString *> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(username);
    NSParameterAssert(password);
    NSParameterAssert(completionHandler);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"grant_type" value:WFOAuth2GrantTypeResourceOwnerPasswordCredentials],
                                              [NSURLQueryItem queryItemWithName:@"username" value:username],
                                              [NSURLQueryItem queryItemWithName:@"password" value:password]];
    
    NSString *scope = [[self class] combinedScopeFromScopes:scopes];
    if (scope)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"scope" value:scope]];
    
    [self authenticateWithParameters:parameters completionHandler:completionHandler];
}

- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(code);
    NSParameterAssert(completionHandler);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"grant_type" value:WFOAuth2GrantTypeAuthorizationCode],
                                              [NSURLQueryItem queryItemWithName:@"code" value:code]];
    
    if (redirectURI)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:redirectURI.absoluteString]];
    
    [self authenticateWithParameters:parameters completionHandler:completionHandler];
}

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(refreshCredential.refreshToken);
    NSParameterAssert(completionHandler);
    
    [self authenticateWithParameters:@[[NSURLQueryItem queryItemWithName:@"grant_type" value:WFOAuth2GrantTypeRefreshToken],
                                       [NSURLQueryItem queryItemWithName:@"refresh_token" value:refreshCredential.refreshToken]]
                   completionHandler:completionHandler];
}

- (void)authenticateWithParameters:(NSArray<NSURLQueryItem *> *)parameters
                 completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(parameters);
    NSParameterAssert(completionHandler);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.tokenURL];
    [request setHTTPMethod:@"POST"];
    
    WFOAuth2AuthMethod authenticationMethod = self.authenticationMethod;
    if ([authenticationMethod isEqualToString:WFOAuth2AuthMethodClientSecretBasicAuth]) {
        [request wfo_setAuthorizationWithUsername:self.clientID password:self.clientSecret];
    } else if ([authenticationMethod isEqualToString:WFOAuth2AuthMethodClientSecretPostBody]) {
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID]];
        
        NSString *clientSecret = self.clientSecret;
        if (clientSecret.length)
            parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"client_secret" value:clientSecret]];
    }
    
    [request wfo_setBodyWithQueryItems:parameters];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable __unused response, NSError * __nullable error) {
        if (!data.length) {
            completionHandler(nil, error);
            return;
        }
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        // Some servers incorrectly respond with a form encoded body
        if (!responseObject) {
            NSURLComponents *components = [NSURLComponents new];
            components.query = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSArray<NSURLQueryItem *> *queryItems = components.queryItems;
            if (queryItems.count) {
                NSMutableDictionary *formObject = [NSMutableDictionary new];
                for (NSURLQueryItem *item in queryItems)
                    [formObject setValue:item.value forKey:item.name];
                
                responseObject = [formObject copy];
                error = nil;
            }
        }
        
        if (!responseObject) {
            completionHandler(nil, error);
            return;
        }
        
        NSString *refreshToken = nil;
        for (NSURLQueryItem *item in parameters) {
            if ([item.name isEqualToString:@"refresh_token"]) {
                refreshToken = item.value;
                break;
            }
        }
        
        NSString *newRefreshToken = responseObject[@"refresh_token"];
        if (refreshToken && !newRefreshToken) {
            NSMutableDictionary *newResponseObject = [responseObject mutableCopy];
            newResponseObject[@"refresh_token"] = refreshToken;
            responseObject = [newResponseObject copy];
        }
        
        WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];
        completionHandler(credential, (error ?: WFRFC6749Section5_2ErrorFromResponse(responseObject)));
    }] resume];
}

- (WFOAuth2AuthorizationSession *)authorizationSessionWithResponseType:(WFOAuth2ResponseType)responseType
                                                                scopes:(nullable NSArray<NSString *> *)scopes
                                                           redirectURI:(nullable NSURL *)redirectURI
                                                     completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [self authorizationSessionWithAuthorizationURL:self.authorizationURL
                                             responseType:responseType
                                                   scopes:scopes
                                              redirectURI:redirectURI
                                        completionHandler:completionHandler];
}

- (WFOAuth2AuthorizationSession *)authorizationSessionWithAuthorizationURL:(NSURL *)authorizationURL
                                                              responseType:(WFOAuth2ResponseType)responseType
                                                                    scopes:(nullable NSArray<NSString *> *)scopes
                                                               redirectURI:(nullable NSURL *)redirectURI
                                                         completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {    
    NSString *scope = [[self class] combinedScopeFromScopes:scopes];
    
    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray new];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID]];
    if (scope)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"scope" value:scope]];

    return [[WFOAuth2AuthorizationSession alloc] initWithSessionManager:self
                                                       authorizationURL:[authorizationURL wfo_URLByAppendingQueryItems:parameters]
                                                           responseType:responseType
                                                            redirectURI:redirectURI
                                                      completionHandler:completionHandler];
}

#if __has_include(<WebKit/WebKit.h>)
- (WKWebView *)authorizationWebViewWithResponseType:(WFOAuth2ResponseType)responseType
                                             scopes:(nullable NSArray<NSString *> *)scopes
                                        redirectURI:(nullable NSURL *)redirectURI
                                  completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    WFOAuth2AuthorizationSession *authorizationSession = [self authorizationSessionWithResponseType:responseType scopes:scopes redirectURI:redirectURI completionHandler:completionHandler];
    return [[WFOAuth2WebView alloc] initWithAuthorizationSession:authorizationSession];
}
#endif

@end

NS_ASSUME_NONNULL_END
