//
//  WFOAuth2AuthorizationSession.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#import <SafariServices/SFSafariViewController.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2AuthorizationSession : NSObject

@property (nonatomic, readonly, strong) NSURL *authorizationURL;
#if TARGET_OS_IOS
@property (nonatomic, readonly) SFSafariViewController *safariViewController NS_AVAILABLE_IOS(9_0);
#endif

- (BOOL)resumeSessionWithURL:(NSURL *)URL;
#if TARGET_OS_IOS
- (BOOL)resumeSessionWithURL:(NSURL *)URL options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0);
#endif

@end

NS_ASSUME_NONNULL_END
