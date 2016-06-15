//
//  WFSlackOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>
#import <WFOAuth2/WFOAuth2Defines.h>

NS_ASSUME_NONNULL_BEGIN

WF_EXTERN NSString * const WFSlackChannelWriteScope;
WF_EXTERN NSString * const WFSlackChannelHistoryScope;
WF_EXTERN NSString * const WFSlackChannelReadScope;
WF_EXTERN NSString * const WFSlackChannelWriteAsUserScope;
WF_EXTERN NSString * const WFSlackChannelWriteAsBotScope;
WF_EXTERN NSString * const WFSlackDoNotDisturbWriteScope;
WF_EXTERN NSString * const WFSlackDoNotDisturbReadScope;
WF_EXTERN NSString * const WFSlackEmojiReadScope;
WF_EXTERN NSString * const WFSlackFileWriteAsUserScope;
WF_EXTERN NSString * const WFSlackFileReadScope;
WF_EXTERN NSString * const WFSlackGroupWriteScope;
WF_EXTERN NSString * const WFSlackGroupHistoryScope;
WF_EXTERN NSString * const WFSlackGroupReadScope;
WF_EXTERN NSString * const WFSlackDirectMessageWriteScope;
WF_EXTERN NSString * const WFSlackDirectMessageHistoryScope;
WF_EXTERN NSString * const WFSlackDirectMessageReadScope;
WF_EXTERN NSString * const WFSlackMultipartyDirectMessageWriteScope;
WF_EXTERN NSString * const WFSlackMultipartyDirectMessageHistoryScope;
WF_EXTERN NSString * const WFSlackMultipartyDirectMessageReadScope;

@interface WFSlackOAuth2SessionManager : WFOAuth2SessionManager <WFOAuth2ProviderSessionManager>

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
