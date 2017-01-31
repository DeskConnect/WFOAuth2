//
//  WFOAuth2ProviderSessionManagerSubclass.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2ProviderSessionManager ()

@property (nonatomic, readonly, strong) NSURLSession *session;

@property (nonatomic, readonly, copy) NSString *clientID;
@property (nonatomic, readonly, copy, nullable) NSString *clientSecret;

+ (BOOL)basicAuthEnabled;
+ (NSURL *)baseURL;
+ (NSString *)tokenPath;

+ (NSURL *)authorizationURL;
+ (WFOAuth2ResponseType)responseType;

@end

NS_ASSUME_NONNULL_END
