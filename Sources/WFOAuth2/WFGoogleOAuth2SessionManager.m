//
//  WFGoogleOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFOAuth2Error.h>

#import <WFOAuth2/WFGoogleOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const WFGoogleNativeRedirectURIString = @"urn:ietf:wg:oauth:2.0:oob:auto";

WFGoogleOAuth2Scope const WFGoogleEmailScope = @"email";
WFGoogleOAuth2Scope const WFGoogleProfileScope = @"profile";

@implementation WFGoogleOAuth2SessionManager

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
                                     tokenURL:[NSURL URLWithString:@"https://www.googleapis.com/oauth2/v4/token"]
                             authorizationURL:[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/v2/auth"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSURLComponents *components = [NSURLComponents componentsWithString:@"https://accounts.google.com/o/oauth2/revoke"];
    components.queryItems = @[[NSURLQueryItem queryItemWithName:@"token" value:credential.accessToken]];
    
    [[self.session dataTaskWithURL:components.URL completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (data.length) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            error = (WFRFC6749Section5_2ErrorFromResponse(responseObject) ?: error);
        }
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (completionHandler)
            completionHandler([[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode], error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END
