//
//  WFSlackOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2Defines.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFSlackOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
WF_EXTERN WFSlackOAuth2Scope const WFSlackChannelWriteScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackChannelHistoryScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackChannelReadScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackChannelWriteAsUserScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackChannelWriteAsBotScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackDoNotDisturbWriteScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackDoNotDisturbReadScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackEmojiReadScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackFileWriteAsUserScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackFileReadScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackGroupWriteScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackGroupHistoryScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackGroupReadScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackDirectMessageWriteScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackDirectMessageHistoryScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackDirectMessageReadScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageWriteScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageHistoryScope;
WF_EXTERN WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageReadScope;

@interface WFSlackOAuth2SessionManager : WFOAuth2SessionManager<WFSlackOAuth2Scope>

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret;

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret;

- (void)authenticateWithScopes:(nullable NSArray<WFSlackOAuth2Scope> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFSlackOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
