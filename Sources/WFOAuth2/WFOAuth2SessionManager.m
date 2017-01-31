//
//  WFOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <objc/runtime.h>

#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

NS_ASSUME_NONNULL_BEGIN

#if __has_include(<WebKit/WebKit.h>)

@interface WFOAuth2WebView : WKWebView <WKNavigationDelegate>

@property (nonatomic, copy, nullable) void (^titleChangeHandler)(NSString *title);
@property (nonatomic, copy, nullable) WKNavigationActionPolicy (^decisionHandler)(NSURLRequest *request);

@end

#endif

typedef NSString *WFOAuth2GrantType NS_EXTENSIBLE_STRING_ENUM;
WFOAuth2GrantType const WFOAuth2GrantTypeResourceOwnerPasswordCredentials = @"password";
WFOAuth2GrantType const WFOAuth2GrantTypeClientCredentials = @"client_credentials";
WFOAuth2GrantType const WFOAuth2GrantTypeAuthorizationCode = @"authorization_code";
WFOAuth2GrantType const WFOAuth2GrantTypeRefreshToken = @"refresh_token";

WFOAuth2ResponseType const WFOAuth2ResponseTypeCode = @"code";
WFOAuth2ResponseType const WFOAuth2ResponseTypeToken = @"token";

@implementation WFOAuth2SessionManager

- (instancetype)initWithBaseURL:(NSURL *)baseURL
                       clientID:(NSString *)clientID
                   clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil baseURL:baseURL basicAuthEnabled:NO clientID:clientID clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                     baseURL:(NSURL *)baseURL
                            basicAuthEnabled:(BOOL)basicAuthEnabled
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    NSParameterAssert(baseURL);
    NSParameterAssert(clientID);
    self = [super init];
    if (!self)
        return nil;
    
    _session = [NSURLSession sessionWithConfiguration:(configuration ?: [NSURLSessionConfiguration defaultSessionConfiguration])];
    _basicAuthEnabled = basicAuthEnabled;
    _baseURL = [baseURL copy];
    _clientID = [clientID copy];
    _clientSecret = [clientSecret copy];

    return self;
}

- (void)authenticateWithPath:(NSString *)path
                       scope:(nullable NSString *)scope
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler{
    NSParameterAssert(path);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"grant_type" value:WFOAuth2GrantTypeClientCredentials]];
    
    if (scope)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"scope" value:scope]];
    
    [self authenticateWithPath:path parameters:parameters completionHandler:completionHandler];
}

- (void)authenticateWithPath:(NSString *)path
                    username:(NSString *)username
                    password:(NSString *)password
                       scope:(nullable NSString *)scope
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(path);
    NSParameterAssert(username);
    NSParameterAssert(password);
    NSParameterAssert(completionHandler);

    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"grant_type" value:WFOAuth2GrantTypeResourceOwnerPasswordCredentials],
                                              [NSURLQueryItem queryItemWithName:@"username" value:username],
                                              [NSURLQueryItem queryItemWithName:@"password" value:password]];
    
    if (scope)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"scope" value:scope]];
    
    [self authenticateWithPath:path parameters:parameters completionHandler:completionHandler];
}

- (void)authenticateWithPath:(NSString *)path
                        code:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(path);
    NSParameterAssert(code);
    NSParameterAssert(completionHandler);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"grant_type" value:WFOAuth2GrantTypeAuthorizationCode],
                                              [NSURLQueryItem queryItemWithName:@"code" value:code]];
    
    if (redirectURI)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:redirectURI.absoluteString]];
    
    [self authenticateWithPath:path parameters:parameters completionHandler:completionHandler];
}

- (void)authenticateWithPath:(NSString *)path
           refreshCredential:(WFOAuth2Credential *)refreshCredential
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(path);
    NSParameterAssert(refreshCredential.refreshToken);
    NSParameterAssert(completionHandler);

    [self authenticateWithPath:path
                    parameters:@[[NSURLQueryItem queryItemWithName:@"grant_type" value:WFOAuth2GrantTypeRefreshToken],
                                 [NSURLQueryItem queryItemWithName:@"refresh_token" value:refreshCredential.refreshToken]]
             completionHandler:completionHandler];
}

- (void)authenticateWithPath:(NSString *)path
                  parameters:(NSArray<NSURLQueryItem *> *)parameters
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(path);
    NSParameterAssert(parameters);
    NSParameterAssert(completionHandler);
    
    NSURL *url = [self.baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    if (self.basicAuthEnabled) {
        [request wfo_setAuthorizationWithUsername:self.clientID password:self.clientSecret];
    } else {
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID]];
        
        if (self.clientSecret)
            parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"client_secret" value:self.clientSecret]];
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
        
        NSString *oldRefreshToken = [[[parameters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = \"refresh_token\""]] firstObject] value];
        NSString *newRefreshToken = responseObject[@"refresh_token"];
        if (oldRefreshToken && !newRefreshToken) {
            NSMutableDictionary *newResponseObject = [responseObject mutableCopy];
            newResponseObject[@"refresh_token"] = oldRefreshToken;
            responseObject = [newResponseObject copy];
        }
        
        WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];
        completionHandler(credential, (error ?: WFRFC6749Section5_2ErrorFromResponse(responseObject)));
    }] resume];
}

- (NSURLRequest *)authorizationRequestWithURL:(NSURL *)authorizationURL
                                 responseType:(WFOAuth2ResponseType)responseType
                                        scope:(nullable NSString *)scope
                                  redirectURI:(nullable NSURL *)redirectURI
                                        state:(nullable NSString *)state {
    NSParameterAssert(authorizationURL);
    NSParameterAssert(responseType);
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:authorizationURL resolvingAgainstBaseURL:NO];
    
    NSMutableArray<NSURLQueryItem *> *parameters = ([components.queryItems mutableCopy] ?: [NSMutableArray new]);
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"response_type" value:responseType]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID]];
    if (scope)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"scope" value:scope]];
    if (redirectURI)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"redirect_uri" value:redirectURI.absoluteString]];
    if (state)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"state" value:state]];

    components.queryItems = parameters;
    
    return [NSURLRequest requestWithURL:components.URL];
}

#if __has_include(<WebKit/WebKit.h>)

- (WKWebView *)authorizationWebViewWithURL:(NSURL *)authorizationURL
                              responseType:(WFOAuth2ResponseType)responseType
                                     scope:(nullable NSString *)scope
                               redirectURI:(nullable NSURL *)redirectURI
                                 tokenPath:(nullable NSString *)tokenPath
                         completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(authorizationURL);
    NSParameterAssert(responseType);
    NSParameterAssert(completionHandler);
    NSAssert(tokenPath || ![responseType isEqualToString:WFOAuth2ResponseTypeCode],
             @"A token path must be provided for response type \"code\"");
    
    NSDictionary<WFOAuth2ResponseType, NSString *> *mapping = @{WFOAuth2ResponseTypeCode: @"code",
                                                                WFOAuth2ResponseTypeToken: @"access_token"};
    NSString *responseKey = mapping[responseType];
    NSAssert(responseKey, @"Unknown response type \"%@\"", responseType);
    
    NSString *state = [[[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
    
    void (^callbackHandler)(NSDictionary<NSString *, NSString *> *) = ^(NSDictionary<NSString *, NSString *> *responseObject) {
        NSError *error = WFRFC6749Section5_2ErrorFromResponse(responseObject);
        if (error) {
            completionHandler(nil, error);
            return;
        }
        
        if (state.length && ![responseObject[@"state"] isEqualToString:state]) {
            completionHandler(nil, [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2InvalidCallbackError userInfo:@{NSLocalizedDescriptionKey: @"The state parameter on the received callback was invalid."}]);
            return;
        }
        
        NSString *value = responseObject[responseKey];
        if (!value.length) {
            completionHandler(nil, [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2InvalidCallbackError userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat: @"The \"%@\" parameter on the received callback was missing.", responseKey]}]);
            return;
        }
        
        if ([responseType isEqualToString:WFOAuth2ResponseTypeCode]) {
            [self authenticateWithPath:tokenPath
                                  code:value
                           redirectURI:redirectURI
                     completionHandler:completionHandler];
        } else if ([responseType isEqualToString:WFOAuth2ResponseTypeToken]) {
            NSError *error = WFRFC6749Section5_2ErrorFromResponse(responseObject);
            WFOAuth2Credential *credential = [[WFOAuth2Credential alloc] initWithResponseObject:responseObject];
            completionHandler(credential, error);
        }
    };
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    if ([configuration respondsToSelector:@selector(setWebsiteDataStore:)])
        configuration.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];
    
    WFOAuth2WebView *webView = [[WFOAuth2WebView alloc] initWithFrame:CGRectZero configuration:configuration];
    __weak __typeof__(webView) weakWebView = webView;
    
    [webView setDecisionHandler:^(NSURLRequest *request) {
        NSURLComponents *components = [NSURLComponents componentsWithURL:request.URL resolvingAgainstBaseURL:NO];
        NSURLComponents *redirectComponents = (redirectURI ? [NSURLComponents componentsWithURL:redirectURI resolvingAgainstBaseURL:NO] : nil);

        NSMutableDictionary *responseObject = [NSMutableDictionary new];
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
                return WKNavigationActionPolicyAllow;
            
            callbackHandler(responseObject);
            return WKNavigationActionPolicyCancel;
        } else {
            if ((responseObject[responseKey] && responseObject[@"state"]) || responseObject[@"error"]) {
                callbackHandler(responseObject);
                return WKNavigationActionPolicyCancel;
            }
            return WKNavigationActionPolicyAllow;
        }        
    }];
    
    // Google puts the code in the title of the web view
    [webView setTitleChangeHandler:^(NSString *title) {
        NSMutableDictionary *responseObject = [NSMutableDictionary new];
        
        for (NSString *component in [title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) {
            NSURLComponents *components = [NSURLComponents new];
            components.query = component;
            
            for (NSURLQueryItem *item in components.queryItems)
                [responseObject setValue:item.value forKey:item.name];
        }
        
        if (responseObject[responseKey] || responseObject[@"state"] || responseObject[@"error"]) {
            [weakWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
            callbackHandler(responseObject);
        }
    }];
    
    [webView loadRequest:[self authorizationRequestWithURL:authorizationURL
                                              responseType:responseType
                                                     scope:scope
                                               redirectURI:redirectURI
                                                     state:state]];
    
    return webView;
}

#endif

@end

#if __has_include(<WebKit/WebKit.h>)

static void *WFOAuth2WebViewTitleContext = &WFOAuth2WebViewTitleContext;

@implementation WFOAuth2WebView {
    id<WKNavigationDelegate> _realNavigationDelegate;
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    self = [super initWithFrame:frame configuration:configuration];
    if (!self)
        return nil;
    
    [super setNavigationDelegate:self];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:0 context:WFOAuth2WebViewTitleContext];

    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(title)) context:WFOAuth2WebViewTitleContext];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == WFOAuth2WebViewTitleContext) {
        void (^titleChangeHandler)(NSString *) = self.titleChangeHandler;
        if (titleChangeHandler) {
            titleChangeHandler(self.title);
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setNavigationDelegate:(nullable id<WKNavigationDelegate>)navigationDelegate {
    _realNavigationDelegate = navigationDelegate;
}

- (id)forwardingTargetForSelector:(SEL)selector {
    BOOL navigationDelegateMethod = (protocol_getMethodDescription(@protocol(WKNavigationDelegate), selector, NO, YES).name != NULL);
    return (navigationDelegateMethod && ![super respondsToSelector:selector] ? _realNavigationDelegate : nil);
}

- (BOOL)respondsToSelector:(SEL)selector {
    return ([super respondsToSelector:selector] || [_realNavigationDelegate respondsToSelector:selector]);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    WKNavigationActionPolicy (^customDecisionHandler)(NSURLRequest *) = self.decisionHandler;
    WKNavigationActionPolicy policy = (customDecisionHandler ? customDecisionHandler(navigationAction.request) : WKNavigationActionPolicyAllow);
    
    if (policy != WKNavigationActionPolicyAllow) {
        decisionHandler(policy);
        return;
    }
    
    if ([_realNavigationDelegate respondsToSelector:_cmd]) {
        [_realNavigationDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        return;
    }
    
    decisionHandler(policy);
}

@end

#endif

NS_ASSUME_NONNULL_END
