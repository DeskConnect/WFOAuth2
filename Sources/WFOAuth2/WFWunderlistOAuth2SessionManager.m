//
//  WFWunderlistOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/21/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFWunderlistOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@implementation WFWunderlistOAuth2SessionManager

#pragma mark - WFOAuth2ProviderSessionManager

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
                                     tokenURL:[NSURL URLWithString:@"https://www.wunderlist.com/oauth/access_token"]
                             authorizationURL:[NSURL URLWithString:@"https://www.wunderlist.com/oauth/authorize"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

@end

NS_ASSUME_NONNULL_END
