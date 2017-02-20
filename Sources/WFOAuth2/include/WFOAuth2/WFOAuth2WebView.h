//
//  WFOAuth2WebView.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#if __has_include(<WebKit/WebKit.h>)

#import <WebKit/WebKit.h>
#import <WFOAuth2/WFOAuth2AuthorizationSession.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2WebView : WKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (instancetype)initWithAuthorizationSession:(WFOAuth2AuthorizationSession *)authorizationSession NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif
