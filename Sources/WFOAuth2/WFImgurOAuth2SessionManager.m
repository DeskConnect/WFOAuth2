//
//  WFImgurOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/21/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFImgurOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFOAuth2Error.h>

NS_ASSUME_NONNULL_BEGIN

static inline __nullable id WFEnforceClass(id __nullable obj, Class objectClass) {
    return ([obj isKindOfClass:objectClass] ? obj : nil);
}

@implementation WFImgurOAuth2SessionManager

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
                                     tokenURL:[NSURL URLWithString:@"https://api.imgur.com/oauth2/token"]
                             authorizationURL:[NSURL URLWithString:@"https://api.imgur.com/oauth2/authorize"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

- (void)sendRequest:(NSURLRequest *)request completionHandler:(void (^)(NSDictionary * __nullable responseObject, NSHTTPURLResponse * __nullable response, NSError * __nullable error))completionHandler {
    [super sendRequest:request completionHandler:^(NSDictionary * __nullable responseObject, NSHTTPURLResponse * __nullable __unused response, NSError * __nullable error) {
        NSDictionary *dataObject = WFEnforceClass(responseObject[@"data"], [NSDictionary class]);
        NSString *errorDescription = WFEnforceClass(dataObject[@"error"], [NSString class]);
        if (!error && errorDescription) {
            error = [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2ErrorUnknown userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
        }
        completionHandler(responseObject, response, error);
    }];
}

@end

NS_ASSUME_NONNULL_END
