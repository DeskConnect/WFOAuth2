//
//  WFUberOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>
#import <WFOAuth2/WFOAuth2Defines.h>

NS_ASSUME_NONNULL_BEGIN

WF_EXTERN NSString * const WFUberUserProfileScope;
WF_EXTERN NSString * const WFUberUserHistoryScope;
WF_EXTERN NSString * const WFUberUserHistoryLiteScope;
WF_EXTERN NSString * const WFUberUserPlacesScope;
WF_EXTERN NSString * const WFUberRequestRideScope;
WF_EXTERN NSString * const WFUberRequestReceiptScope;
WF_EXTERN NSString * const WFUberAllTripsScope;

@interface WFUberOAuth2SessionManager : WFOAuth2SessionManager <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (void)authenticateWithScope:(nullable NSString *)scope
            completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
