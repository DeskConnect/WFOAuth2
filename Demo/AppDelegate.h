//
//  AppDelegate.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFOAuth2/WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong, nullable) WFOAuth2AuthorizationSession *currentSession;

@end

NS_ASSUME_NONNULL_END
