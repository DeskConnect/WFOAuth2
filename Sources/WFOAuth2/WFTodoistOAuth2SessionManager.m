//
//  WFTodoistOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/21/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFTodoistOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/WFOAuth2Credential.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

NS_ASSUME_NONNULL_BEGIN

WFTodoistOAuth2Scope const WFTodoistAddTaskScope = @"task:add";
WFTodoistOAuth2Scope const WFTodoistReadDataScope = @"data:read";
WFTodoistOAuth2Scope const WFTodoistReadWriteDataScope = @"data:read_write";
WFTodoistOAuth2Scope const WFTodoistDeleteDataScope = @"data:delete";
WFTodoistOAuth2Scope const WFTodoistDeleteProjectScope = @"project:delete";

@implementation WFTodoistOAuth2SessionManager

+ (nullable NSString *)combinedScopeFromScopes:(nullable NSArray<NSString *> *)scopes {
    return [scopes componentsJoinedByString:@","];
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
    return [self initWithSessionConfiguration:configuration
                                     tokenURL:[NSURL URLWithString:@"https://todoist.com/oauth/access_token"]
                             authorizationURL:[NSURL URLWithString:@"https://todoist.com/oauth/authorize"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSURL *url = [NSURL URLWithString:@"https://todoist.com/api/access_tokens/revoke"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    NSMutableDictionary<NSString *, NSString *> *parameters = [NSMutableDictionary new];
    [parameters setObject:self.clientID forKey:@"client_id"];
    [parameters setObject:credential.accessToken forKey:@"access_token"];
    if (self.clientSecret)
        [parameters setObject:self.clientSecret forKey:@"client_secret"];
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Typee"];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (data.length) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            error = (WFRFC6749Section5_2ErrorFromResponse(responseObject) ?: error);
        }
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (completionHandler)
            completionHandler(statusCode == 204, error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END
