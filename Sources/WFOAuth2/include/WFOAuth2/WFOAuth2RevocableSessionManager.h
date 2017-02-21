//
//  WFOAuth2RevocableSessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The `WFOAuth2RevocableSessionManager` protocol is a protocol intended to be adopted by provider-specific subclasses of `WFOAuth2SessionManager` when the provider supports revoking a token.
 */
@protocol WFOAuth2RevocableSessionManager <NSObject>

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
