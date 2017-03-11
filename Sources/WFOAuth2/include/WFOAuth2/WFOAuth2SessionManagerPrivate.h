//
//  WFOAuth2SessionManagerPrivate.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2SessionManager ()

/**
 The managed session. This property should only be referenced by subclasses.
 */
@property (nonatomic, readonly, strong) NSURLSession *session;

+ (nullable NSString *)combinedScopeFromScopes:(nullable NSArray<NSString *> *)scopes;

- (void)authenticateWithRequest:(NSURLRequest *)request
                   refreshToken:(nullable NSString *)refreshToken
              completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

- (WFOAuth2WebAuthorizationSession *)authorizationSessionWithAuthorizationURL:(NSURL *)authorizationURL
                                                                 responseType:(WFOAuth2ResponseType)responseType
                                                                       scopes:(nullable NSArray<NSString *> *)scopes
                                                                  redirectURI:(nullable NSURL *)redirectURI
                                                           specifyRedirectURI:(BOOL)specifyRedirectURI
                                                            completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
