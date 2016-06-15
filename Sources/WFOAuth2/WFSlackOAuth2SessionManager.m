//
//  WFSlackOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

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

static NSString * const WFSlackOAuth2TokenPath = @"oauth.access";

@implementation WFSlackOAuth2SessionManager

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil clientID:clientID clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    return [super initWithSessionConfiguration:configuration baseURL:[NSURL URLWithString:@"https://slack.com/api"] basicAuthEnabled:NO clientID:clientID clientSecret:clientSecret];
}

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFSlackOAuth2TokenPath username:username password:password scope:scope completionHandler:completionHandler];
}

- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFSlackOAuth2TokenPath code:code redirectURI:redirectURI completionHandler:completionHandler];
}

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFSlackOAuth2TokenPath refreshCredential:refreshCredential completionHandler:completionHandler];
}

#if __has_include(<WebKit/WebKit.h>)

- (WKWebView *)authorizationWebViewWithScope:(nullable NSString *)scope
                                 redirectURI:(nullable NSURL *)redirectURI
                           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [super authorizationWebViewWithURL:[NSURL URLWithString:@"https://slack.com/oauth/authorize"] scope:scope redirectURI:redirectURI tokenPath:WFSlackOAuth2TokenPath completionHandler:completionHandler];
}

#endif

@end

NS_ASSUME_NONNULL_END
