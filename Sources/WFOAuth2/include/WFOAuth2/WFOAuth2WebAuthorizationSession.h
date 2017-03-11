//
//  WFOAuth2WebAuthorizationSession.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2AuthorizationSession.h>

#if TARGET_OS_IOS
#import <SafariServices/SFSafariViewController.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2WebAuthorizationSession : NSObject <WFOAuth2AuthorizationSession>

@property (nonatomic, readonly, copy) NSURL *authorizationURL;

@property (nonatomic, readonly, copy, nullable) NSURL *redirectURI;

#if TARGET_OS_IOS
@property (nonatomic, readonly) SFSafariViewController *safariViewController NS_AVAILABLE_IOS(9_0);
#endif

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithSessionManager:(WFOAuth2SessionManager *)sessionManager
                      authorizationURL:(NSURL *)authorizationURL
                          responseType:(WFOAuth2ResponseType)responseType
                           redirectURI:(nullable NSURL *)redirectURI
                    specifyRedirectURI:(BOOL)specifyRedirectURI
                     completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
