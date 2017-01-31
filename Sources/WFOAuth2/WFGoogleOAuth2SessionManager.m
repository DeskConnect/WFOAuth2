//
//  WFGoogleOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFOAuth2Error.h>

#import <WFOAuth2/WFGoogleOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const WFGoogleNativeRedirectURIString = @"urn:ietf:wg:oauth:2.0:oob:auto";
NSString * const WFGoogleEmailScope = @"email";
NSString * const WFGoogleProfileScope = @"profile";

static NSString * const WFGoogleOAuth2TokenPath = @"token";

@implementation WFGoogleOAuth2SessionManager

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret {
    return [self initWithSessionConfiguration:nil clientID:clientID clientSecret:clientSecret];
}

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret {
    return [super initWithSessionConfiguration:configuration baseURL:[NSURL URLWithString:@"https://www.googleapis.com/oauth2/v4"] basicAuthEnabled:NO clientID:clientID clientSecret:clientSecret];
}

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFGoogleOAuth2TokenPath username:username password:password scope:scope completionHandler:completionHandler];
}

- (void)authenticateWithCode:(NSString *)code
                 redirectURI:(nullable NSURL *)redirectURI
           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFGoogleOAuth2TokenPath code:code redirectURI:redirectURI completionHandler:completionHandler];
}

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    [super authenticateWithPath:WFGoogleOAuth2TokenPath refreshCredential:refreshCredential completionHandler:completionHandler];
}

#if __has_include(<WebKit/WebKit.h>)

- (WKWebView *)authorizationWebViewWithScope:(nullable NSString *)scope
                                 redirectURI:(nullable NSURL *)redirectURI
                           completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [super authorizationWebViewWithURL:[NSURL URLWithString:@"https://accounts.google.com/o/oauth2/auth"] responseType:WFOAuth2ResponseTypeCode scope:scope redirectURI:redirectURI tokenPath:WFGoogleOAuth2TokenPath completionHandler:completionHandler];
}

#endif

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
