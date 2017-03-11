//
//  WFUberAppAuthorizationSession.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/7/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFUberOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2AuthorizationSession.h>

#if TARGET_OS_IOS

NS_ASSUME_NONNULL_BEGIN

@interface WFUberAppAuthorizationSession : NSObject <WFOAuth2AuthorizationSession>

@property (nonatomic, readonly) NSURL *authorizationURL;
@property (nonatomic, readonly, copy) NSURL *redirectURI;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithClientID:(NSString *)clientID
                         appName:(NSString *)name
                          scopes:(nullable NSArray<WFUberOAuth2Scope> *)scopes
                     redirectURI:(nullable NSURL *)redirectURI
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif
