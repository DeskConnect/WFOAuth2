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
WFO_EXTERN WFSlackOAuth2Scope const WFSlackChannelWriteScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackChannelHistoryScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackChannelReadScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackChannelWriteAsUserScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackChannelWriteAsBotScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackDoNotDisturbWriteScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackDoNotDisturbReadScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackEmojiReadScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackFileWriteAsUserScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackFileReadScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackGroupWriteScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackGroupHistoryScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackGroupReadScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackDirectMessageWriteScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackDirectMessageHistoryScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackDirectMessageReadScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageWriteScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageHistoryScope;
WFO_EXTERN WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageReadScope;

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
