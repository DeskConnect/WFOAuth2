//
//  WFSlackOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManagerSubclass.h>

#import <WFOAuth2/WFSlackOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const WFSlackChannelWriteScope = @"channels:write";
NSString * const WFSlackChannelHistoryScope = @"channels:history";
NSString * const WFSlackChannelReadScope = @"channels:read";
NSString * const WFSlackChannelWriteAsUserScope = @"chat:write:user";
NSString * const WFSlackChannelWriteAsBotScope = @"chat:write:bot";
NSString * const WFSlackDoNotDisturbWriteScope = @"dnd:write";
NSString * const WFSlackDoNotDisturbReadScope = @"dnd:read";
NSString * const WFSlackEmojiReadScope = @"emoji:read";
NSString * const WFSlackFileWriteAsUserScope = @"files:write:user";
NSString * const WFSlackFileReadScope = @"files:read";
NSString * const WFSlackGroupWriteScope = @"groups:write";
NSString * const WFSlackGroupHistoryScope = @"groups:history";
NSString * const WFSlackGroupReadScope = @"groups:read";
NSString * const WFSlackDirectMessageWriteScope = @"im:write";
NSString * const WFSlackDirectMessageHistoryScope = @"im:history";
NSString * const WFSlackDirectMessageReadScope = @"im:read";
NSString * const WFSlackMultipartyDirectMessageWriteScope = @"mpim:write";
NSString * const WFSlackMultipartyDirectMessageHistoryScope = @"mpim:history";
NSString * const WFSlackMultipartyDirectMessageReadScope = @"mpim:read";

@implementation WFSlackOAuth2SessionManager

+ (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://slack.com/api"];
}

+ (NSString *)tokenPath {
    return @"oauth.access";
}

+ (NSURL *)authorizationURL {
    return [NSURL URLWithString:@"https://slack.com/oauth/authorize"];
}

@end

NS_ASSUME_NONNULL_END
