//
//  WFSlackOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>

#import <WFOAuth2/WFSlackOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

WFSlackOAuth2Scope const WFSlackChannelWriteScope = @"channels:write";
WFSlackOAuth2Scope const WFSlackChannelHistoryScope = @"channels:history";
WFSlackOAuth2Scope const WFSlackChannelReadScope = @"channels:read";
WFSlackOAuth2Scope const WFSlackChannelWriteAsUserScope = @"chat:write:user";
WFSlackOAuth2Scope const WFSlackChannelWriteAsBotScope = @"chat:write:bot";
WFSlackOAuth2Scope const WFSlackDoNotDisturbWriteScope = @"dnd:write";
WFSlackOAuth2Scope const WFSlackDoNotDisturbReadScope = @"dnd:read";
WFSlackOAuth2Scope const WFSlackEmojiReadScope = @"emoji:read";
WFSlackOAuth2Scope const WFSlackFileWriteAsUserScope = @"files:write:user";
WFSlackOAuth2Scope const WFSlackFileReadScope = @"files:read";
WFSlackOAuth2Scope const WFSlackGroupWriteScope = @"groups:write";
WFSlackOAuth2Scope const WFSlackGroupHistoryScope = @"groups:history";
WFSlackOAuth2Scope const WFSlackGroupReadScope = @"groups:read";
WFSlackOAuth2Scope const WFSlackDirectMessageWriteScope = @"im:write";
WFSlackOAuth2Scope const WFSlackDirectMessageHistoryScope = @"im:history";
WFSlackOAuth2Scope const WFSlackDirectMessageReadScope = @"im:read";
WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageWriteScope = @"mpim:write";
WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageHistoryScope = @"mpim:history";
WFSlackOAuth2Scope const WFSlackMultipartyDirectMessageReadScope = @"mpim:read";
WFSlackOAuth2Scope const WFSlackUserReadScope = @"users:read";
WFSlackOAuth2Scope const WFSlackUserWriteScope = @"users:write";

@implementation WFSlackOAuth2SessionManager

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:configuration
                                     tokenURL:[NSURL URLWithString:@"https://slack.com/api/oauth.access"]
                             authorizationURL:[NSURL URLWithString:@"https://slack.com/oauth/authorize"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

@end

NS_ASSUME_NONNULL_END
