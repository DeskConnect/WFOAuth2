//
//  WFDropboxOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFDropboxOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFDropboxAppAuthorizationSession.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/NSURL+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

NS_ASSUME_NONNULL_BEGIN

@implementation WFDropboxOAuth2SessionManager

- (WFOAuth2WebAuthorizationSession *)authorizationSessionWithCompletionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSURL *redirectURI = [NSURL URLWithString:[NSString stringWithFormat:@"db-%@://2/token", self.clientID]];
    return [super authorizationSessionWithResponseType:WFOAuth2ResponseTypeToken scopes:nil redirectURI:redirectURI completionHandler:completionHandler];
}

#if TARGET_OS_IOS
- (WFDropboxAppAuthorizationSession *)appAuthorizationSessionWithCompletionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [[WFDropboxAppAuthorizationSession alloc] initWithClientID:self.clientID completionHandler:completionHandler];
}
#endif

#if __has_include(<WebKit/WebKit.h>)
- (WKWebView *)authorizationWebViewWithRedirectURI:(nullable NSURL *)redirectURI
                                 completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    return [super authorizationWebViewWithResponseType:WFOAuth2ResponseTypeCode scopes:nil redirectURI:redirectURI completionHandler:completionHandler];
}
#endif

- (void)authenticateWithLegacyAccessToken:(NSString *)accessToken
                        accessTokenSecret:(NSString *)accessTokenSecret
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(accessToken);
    NSParameterAssert(accessTokenSecret);
    NSParameterAssert(completionHandler);
    
    NSURL *url = [NSURL URLWithString:@"https://api.dropboxapi.com/1/oauth2/token_from_oauth1"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSString *signature = [@[self.clientSecret, accessTokenSecret] componentsJoinedByString:@"&"];
    
    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray new];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"oauth_version" value:@"1.0"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"oauth_consumer_key" value:self.clientID]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"oauth_token" value:accessToken]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"oauth_signature_method" value:@"PLAINTEXT"]];
    [parameters addObject:[NSURLQueryItem queryItemWithName:@"oauth_signature" value:signature]];
    
    // RFC 5849 section 3.6
    NSMutableCharacterSet *unreservedCharacters = [[NSCharacterSet alphanumericCharacterSet] mutableCopy];
    [unreservedCharacters addCharactersInString:@"-_.~"];
    
    NSMutableArray *components = [NSMutableArray new];
    for (NSURLQueryItem *parameter in parameters) {
        NSString *key = [parameter.name stringByAddingPercentEncodingWithAllowedCharacters:unreservedCharacters];
        NSString *value = [parameter.value stringByAddingPercentEncodingWithAllowedCharacters:unreservedCharacters];
        [components addObject:[NSString stringWithFormat:@"%@=\"%@\"", key, value]];
    }
    
    NSString *authorization = [NSString stringWithFormat:@"OAuth %@", [components componentsJoinedByString:@","]];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    
    [self authenticateWithRequest:request refreshToken:nil completionHandler:completionHandler];
}

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
    NSURL *authorizationURL = [NSURL URLWithString:@"https://www.dropbox.com/1/oauth2/authorize"];
    NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"disable_signup" value:@"true"],
                                              [NSURLQueryItem queryItemWithName:@"locale" value:localeIdentifier]];
    
    return [self initWithSessionConfiguration:configuration
                                     tokenURL:[NSURL URLWithString:@"https://api.dropboxapi.com/1/oauth2/token"]
                             authorizationURL:[authorizationURL wfo_URLByAppendingQueryItems:parameters]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL, NSError * __nullable))completionHandler {
    NSParameterAssert(credential);
    
    NSURL *url = [NSURL URLWithString:@"https://api.dropboxapi.com/1/disable_access_token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request wfo_setAuthorizationWithCredential:credential];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        BOOL success = [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode];
        if (data.length) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            success = !responseObject.count;
            error = (WFRFC6749Section5_2ErrorFromResponse(responseObject) ?: error);
        }
        
        if (completionHandler)
            completionHandler(success, error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END
