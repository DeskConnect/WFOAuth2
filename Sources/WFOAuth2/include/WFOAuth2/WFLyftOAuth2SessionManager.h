//
//  WFLyftOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const WFLyftPublicScope;
extern NSString * const WFLyftReadRidesScope;
extern NSString * const WFLyftRequestRidesScope;
extern NSString * const WFLyftProfileScope;
extern NSString * const WFLyftOfflineScope;

@interface WFLyftOAuth2SessionManager : WFOAuth2SessionManager <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
