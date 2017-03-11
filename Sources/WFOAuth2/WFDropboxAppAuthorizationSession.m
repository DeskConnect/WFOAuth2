//
//  WFDropboxAppAuthorizationSession.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/25/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFDropboxAppAuthorizationSession.h>
#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2Credential.h>
#import <WFOAuth2/NSURL+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

#if TARGET_OS_IOS

NS_ASSUME_NONNULL_BEGIN

@interface WFDropboxAppAuthorizationSession ()

@property (nonatomic, readonly) NSString *clientID;
@property (nonatomic, readonly) NSString *state;
@property (nonatomic, copy, nullable) WFOAuth2AuthenticationHandler completionHandler;

@end

@implementation WFDropboxAppAuthorizationSession

- (instancetype)initWithClientID:(NSString *)clientID completionHandler:(WFOAuth2AuthenticationHandler)completionHandler {
    NSParameterAssert(clientID);
    NSParameterAssert(completionHandler);
    self = [super init];
    if (!self)
        return nil;
    
    _clientID = clientID;
    _state = [@"oauth2:" stringByAppendingString:[[[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString]];
    _successURI = [NSURL URLWithString:[NSString stringWithFormat:@"db-%@://1/connect", _clientID]];
    _cancelURI = [NSURL URLWithString:[NSString stringWithFormat:@"db-%@://1/cancel", _clientID]];
    _completionHandler = completionHandler;

    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"k" value:_clientID],
                                              [NSURLQueryItem queryItemWithName:@"s" value:nil],
                                              [NSURLQueryItem queryItemWithName:@"state" value:_state]];
    
    NSURLComponents *components = [NSURLComponents new];
    components.host = @"1";
    components.path = @"/connect";
    components.queryItems = parameters;

    NSMutableArray<NSURL *> *authorizationURLs = [NSMutableArray new];
    for (NSString *scheme in @[@"dbapi-2", @"dbapi-8-emm"]) {
        components.scheme = scheme;
        [authorizationURLs addObject:components.URL];
    }
    
    _authorizationURLs = authorizationURLs;
    
    return self;
}

#pragma mark - WFOAuth2AuthorizationSession

- (BOOL)resumeSessionWithURL:(NSURL *)URL {
    WFOAuth2AuthenticationHandler completionHandler = self.completionHandler;
    if (!completionHandler) {
        return NO;
    }
    
    if ([URL wfo_isEqualToRedirectURI:self.successURI]) {
        NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
        
        NSMutableDictionary<NSString *, NSString *> *responseObject = [NSMutableDictionary new];
        for (NSURLQueryItem *item in components.queryItems)
            [responseObject setValue:item.value forKey:item.name];
    
        if (![responseObject[@"state"] isEqualToString:self.state]) {
            completionHandler(nil, [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2InvalidCallbackError userInfo:@{NSLocalizedDescriptionKey: @"The state parameter on the received callback was invalid."}]);
            return YES;
        }
        
        NSString *accessToken = responseObject[@"oauth_token_secret"];
        if (!accessToken.length) {
            completionHandler(nil, [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2InvalidCallbackError userInfo:@{NSLocalizedDescriptionKey: @"The \"oauth_token_secret\" parameter on the received callback was missing."}]);
            return YES;
        }
        
        completionHandler([[WFOAuth2Credential alloc] initWithResponseObject:@{@"access_token": accessToken}], nil);
    } else if ([URL wfo_isEqualToRedirectURI:self.cancelURI]) {
        completionHandler(nil, [NSError errorWithDomain:WFOAuth2ErrorDomain code:WFOAuth2AccessDeniedError userInfo:@{NSLocalizedDescriptionKey: @"The user cancelled the request."}]);
    } else {
        return NO;
    }

    self.completionHandler = nil;
    return YES;
}

- (BOOL)resumeSessionWithURL:(NSURL *)URL options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if ([sourceApplication isEqualToString:@"com.getdropbox.Dropbox"]) {
        return [self resumeSessionWithURL:URL];
    }
    
    return NO;
}

@end

NS_ASSUME_NONNULL_END

#endif
