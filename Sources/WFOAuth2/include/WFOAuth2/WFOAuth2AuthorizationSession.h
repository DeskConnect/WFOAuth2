//
//  WFOAuth2AuthorizationSession.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<UIKit/UIKit.h>)
#import <UIKit/UIKit.h>
#endif
#if __has_include(<SafariServices/SFSafariViewController.h>)
#import <SafariServices/SFSafariViewController.h>
#endif

@interface WFOAuth2AuthorizationSession : NSObject

@property (nonatomic, readonly, strong) NSURL *authorizationURL;

#if __has_include(<SafariServices/SFSafariViewController.h>)
@property (nonatomic, readonly) SFSafariViewController *safariViewController;
#endif

- (BOOL)resumeSessionWithURL:(NSURL *)URL;

#if __has_include(<UIKit/UIKit.h>)
- (BOOL)resumeSessionWithURL:(NSURL *)URL options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
#endif

@end
