//
//  LoginViewController.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/25/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import "LoginViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController ()

@property (nonatomic, readonly, strong) WKWebView *webView;

@end

static void *LoginViewControllerTitleContext = &LoginViewControllerTitleContext;

@implementation LoginViewController

- (instancetype)initWithSessionManager:(WFOAuth2ProviderSessionManager *)sessionManager scope:(nullable NSString *)scope redirectURI:(nullable NSURL *)redirectURI {
    self = [super initWithNibName:nil bundle:nil];
    if (!self)
        return nil;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    
    __weak __typeof__(self) weakSelf = self;
    _sessionManager = sessionManager;
    _webView = [sessionManager authorizationWebViewWithScope:scope redirectURI:redirectURI completionHandler:^(WFOAuth2Credential * __nullable credential, NSError * __nullable error) {
        id<LoginViewControllerDelegate> delegate = weakSelf.delegate;
        
        if (credential) {
            if ([delegate respondsToSelector:@selector(loginViewController:didAuthenticateWithCredential:)]) {
                [delegate loginViewController:self didAuthenticateWithCredential:credential];
            }
        } else {
            if ([delegate respondsToSelector:@selector(loginViewController:didFailWithError:)]) {
                [delegate loginViewController:self didFailWithError:error];
            }
        }
    }];
    
    [self addObserver:self forKeyPath:@"webView.title" options:0 context:LoginViewControllerTitleContext];
    
    return self;
}

- (void)dealloc {
    [self addObserver:self forKeyPath:@"webView.title" options:0 context:LoginViewControllerTitleContext];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary *)change context:(nullable void *)context {
    if (context == LoginViewControllerTitleContext) {
        self.title = self.webView.title;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)loadView {
    [super loadView];
    
    WKWebView *webView = self.webView;
    webView.frame = self.view.bounds;
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:webView];
}

- (void)cancelPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(loginViewControllerDidCancel:)])
        [self.delegate loginViewControllerDidCancel:self];
}

@end

NS_ASSUME_NONNULL_END
