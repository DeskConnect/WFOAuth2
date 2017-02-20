//
//  WFOAuth2AuthorizationSessionPrivate.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2AuthorizationSession.h>
#import <WFOAuth2/WFOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2AuthorizationSession ()

@property (nonatomic, readonly, copy) NSString *responseKey;

- (instancetype)initWithSessionManager:(WFOAuth2SessionManager *)sessionManager
                      authorizationURL:(NSURL *)authorizationURL
                          responseType:(WFOAuth2ResponseType)responseType
                           redirectURI:(nullable NSURL *)redirectURI
                     completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;

- (BOOL)resumeSessionWithResponseObject:(NSDictionary<NSString *, NSString *> *)responseObject;

@end

NS_ASSUME_NONNULL_END
