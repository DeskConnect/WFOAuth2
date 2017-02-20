//
//  WFOAuth2SessionManagerPrivate.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2Defines.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2SessionManager ()

/**
 The managed session. This property should only be referenced by subclasses.
 */
@property (nonatomic, readonly, strong) NSURLSession *session;

- (WFOAuth2AuthorizationSession *)authorizationSessionWithAuthorizationURL:(NSURL *)authorizationURL
                                                              responseType:(WFOAuth2ResponseType)responseType
                                                                    scopes:(nullable NSArray<NSString *> *)scopes
                                                               redirectURI:(nullable NSURL *)redirectURI
                                                         completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
