//
//  WFImgurOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/21/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFImgurOAuth2SessionManager : WFOAuth2SessionManager <WFOAuth2ProviderSessionManager>

- (void)authenticateWithScopes:(nullable NSArray<NSString *> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<NSString *> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
