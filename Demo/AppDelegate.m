//
//  AppDelegate.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([self.currentSession resumeSessionWithURL:url options:options]) {
        self.currentSession = nil;
        return YES;
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END
