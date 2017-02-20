//
//  WFOAuth2WebView.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#if __has_include(<WebKit/WebKit.h>)

#import <objc/runtime.h>

#import <WFOAuth2/WFOAuth2WebView.h>
#import <WFOAuth2/WFOAuth2AuthorizationSessionPrivate.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2WebView () <WKNavigationDelegate>

@property (nonatomic, readonly, strong) WFOAuth2AuthorizationSession *authorizationSession;
@property (nonatomic, weak) id<WKNavigationDelegate> realNavigationDelegate;

@end

static void *WFOAuth2WebViewTitleContext = &WFOAuth2WebViewTitleContext;

@implementation WFOAuth2WebView

- (instancetype)initWithAuthorizationSession:(WFOAuth2AuthorizationSession *)authorizationSession {
    NSParameterAssert(authorizationSession);
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    if ([configuration respondsToSelector:@selector(setWebsiteDataStore:)])
        configuration.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];
    
    self = [super initWithFrame:CGRectZero configuration:configuration];
    if (!self)
        return nil;
    
    _authorizationSession = authorizationSession;
    
    [super setNavigationDelegate:self];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(title)) options:0 context:WFOAuth2WebViewTitleContext];
    
    [self loadRequest:[NSURLRequest requestWithURL:authorizationSession.authorizationURL]];
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(title)) context:WFOAuth2WebViewTitleContext];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == WFOAuth2WebViewTitleContext) {
        NSMutableDictionary<NSString *, NSString *> *responseObject = [NSMutableDictionary new];
        
        for (NSString *component in [self.title componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) {
            NSURLComponents *components = [NSURLComponents new];
            components.query = component;
            
            for (NSURLQueryItem *item in components.queryItems)
                [responseObject setValue:item.value forKey:item.name];
        }
        
        WFOAuth2AuthorizationSession *authorizationSession = self.authorizationSession;
        NSString *responseKey = authorizationSession.responseKey;
        if (responseObject[responseKey] || responseObject[@"state"] || responseObject[@"error"]) {
            [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
            [authorizationSession resumeSessionWithResponseObject:responseObject];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setNavigationDelegate:(nullable id<WKNavigationDelegate>)navigationDelegate {
    _realNavigationDelegate = navigationDelegate;
}

- (nullable id)forwardingTargetForSelector:(SEL)selector {
    BOOL navigationDelegateMethod = (protocol_getMethodDescription(@protocol(WKNavigationDelegate), selector, NO, YES).name != NULL);
    return (navigationDelegateMethod && ![super respondsToSelector:selector] ? _realNavigationDelegate : nil);
}

- (BOOL)respondsToSelector:(SEL)selector {
    return ([super respondsToSelector:selector] || [self.realNavigationDelegate respondsToSelector:selector]);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([self.authorizationSession resumeSessionWithURL:navigationAction.request.URL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    id<WKNavigationDelegate> realNavigationDelegate = self.realNavigationDelegate;
    if ([realNavigationDelegate respondsToSelector:_cmd]) {
        [realNavigationDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end

NS_ASSUME_NONNULL_END

#endif
