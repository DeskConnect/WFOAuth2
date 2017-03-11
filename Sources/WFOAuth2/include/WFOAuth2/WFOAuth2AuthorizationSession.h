//
//  WFOAuth2AuthorizationSession.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/11/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol WFOAuth2AuthorizationSession <NSObject>

- (BOOL)resumeSessionWithURL:(NSURL *)URL;
#if TARGET_OS_IOS || TARGET_OS_TV
- (BOOL)resumeSessionWithURL:(NSURL *)URL options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options NS_AVAILABLE_IOS(9_0);
#endif

@end

NS_ASSUME_NONNULL_END
