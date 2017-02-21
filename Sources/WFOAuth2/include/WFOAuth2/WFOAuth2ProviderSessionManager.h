//
//  WFOAuth2ProviderSessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/20/2017.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The `WFOAuth2ProviderSessionManager` protocol is a protocol intended to be adopted by provider-specific subclasses of `WFOAuth2SessionManager` to simplify initializing the session manager.
 */
@protocol WFOAuth2ProviderSessionManager <NSObject>

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret;

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret;

@end

NS_ASSUME_NONNULL_END
