//
//  WFBoxAppAuthorizationSession.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/11/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFBoxOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2AuthorizationSession.h>

#if TARGET_OS_IOS

NS_ASSUME_NONNULL_BEGIN

@interface WFBoxAppAuthorizationSession : NSObject <WFOAuth2AuthorizationSession>

@property (nonatomic, readonly) NSURL *authorizationURL;
@property (nonatomic, readonly) NSURL *redirectURI;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSessionManager:(WFBoxOAuth2SessionManager *)sessionManager
                               appName:(NSString *)name
                           redirectURI:(nullable NSURL *)redirectURI
                     completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif
