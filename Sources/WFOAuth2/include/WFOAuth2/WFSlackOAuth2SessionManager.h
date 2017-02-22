//
//  WFSlackOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFSlackOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
extern WFSlackOAuth2Scope const WFSlackChannelWriteScope;
extern WFSlackOAuth2Scope const WFSlackChannelHistoryScope;
extern WFSlackOAuth2Scope const WFSlackChannelReadScope;
extern WFSlackOAuth2Scope const WFSlackChannelWriteAsUserScope;
extern WFSlackOAuth2Scope const WFSlackChannelWriteAsBotScope;
extern WFSlackOAuth2Scope const WFSlackDoNotDisturbWriteScope;
extern WFSlackOAuth2Scope const WFSlackDoNotDisturbReadScope;
extern WFSlackOAuth2Scope const WFSlackEmojiReadScope;
extern WFSlackOAuth2Scope const WFSlackFileWriteAsUserScope;
extern WFSlackOAuth2Scope const WFSlackFileReadScope;
extern WFSlackOAuth2Scope const WFSlackGroupWriteScope;
extern WFSlackOAuth2Scope const WFSlackGroupHistoryScope;
extern WFSlackOAuth2Scope const WFSlackGroupReadScope;
extern WFSlackOAuth2Scope const WFSlackDirectMessageWriteScope;
extern WFSlackOAuth2Scope const WFSlackDirectMessageHistoryScope;
extern WFSlackOAuth2Scope const WFSlackDirectMessageReadScope;
extern WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageWriteScope;
extern WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageHistoryScope;
extern WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageReadScope;
extern WFSlackOAuth2Scope const WFSlackUserReadScope;
extern WFSlackOAuth2Scope const WFSlackUserWriteScope;

@interface WFSlackOAuth2SessionManager : WFOAuth2SessionManager<WFSlackOAuth2Scope> <WFOAuth2ProviderSessionManager>

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
