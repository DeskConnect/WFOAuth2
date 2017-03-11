//
//  WFVenmoAppAuthorizationSession.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/7/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFVenmoOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2AuthorizationSession.h>

#if TARGET_OS_IOS

NS_ASSUME_NONNULL_BEGIN

@interface WFVenmoAppAuthorizationSession : NSObject <WFOAuth2AuthorizationSession>

@property (nonatomic, readonly) NSURL *authorizationURL;
@property (nonatomic, readonly) NSURL *redirectURI;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSessionManager:(WFVenmoOAuth2SessionManager *)sessionManager
                                scopes:(nullable NSArray<WFVenmoOAuth2Scope> *)scopes
                     completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif
