//
//  WFDropboxAppAuthorizationSession.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/25/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2AuthorizationSession.h>

#if TARGET_OS_IOS

NS_ASSUME_NONNULL_BEGIN

@interface WFDropboxAppAuthorizationSession : NSObject <WFOAuth2AuthorizationSession>

@property (nonatomic, readonly) NSArray<NSURL *> *authorizationURLs;
@property (nonatomic, readonly) NSURL *successURI;
@property (nonatomic, readonly) NSURL *cancelURI;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithClientID:(NSString *)clientID completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif
