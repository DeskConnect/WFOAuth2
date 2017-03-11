//
//  WFBoxOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/7/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFBoxOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2SessionManagerPrivate.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Credential.h>
#import <WFOAuth2/WFOAuth2Error.h>

NS_ASSUME_NONNULL_BEGIN

WFBoxOAuth2Scope const WFBoxReadWriteScope = @"root_readwrite";
WFBoxOAuth2Scope const WFBoxManageEnterpriseScope = @"manage_enterprise";
WFBoxOAuth2Scope const WFBoxManageManagedUsersScope = @"manage_managed_users";
WFBoxOAuth2Scope const WFBoxManageGroupsScope = @"manage_groups";
WFBoxOAuth2Scope const WFBoxManagePropertiesScope = @"manage_enterprise_properties";
WFBoxOAuth2Scope const WFBoxManageDataRetentionScope = @"manage_data_retention";
WFBoxOAuth2Scope const WFBoxManageAppUsersScope = @"manage_app_users";
WFBoxOAuth2Scope const WFBoxManageWebhooksScope = @"manage_webhook";

@implementation WFBoxOAuth2SessionManager

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
                                     tokenURL:[NSURL URLWithString:@"https://api.box.com/oauth2/token"]
                             authorizationURL:[NSURL URLWithString:@"https://account.box.com/api/oauth2/authorize"]
                         authenticationMethod:WFOAuth2AuthMethodClientSecretPostBody
                                     clientID:clientID
                                 clientSecret:clientSecret];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL, NSError * __nullable))completionHandler {
    NSParameterAssert(credential);
    
    NSArray<NSURLQueryItem *> *parameters = @[[NSURLQueryItem queryItemWithName:@"client_id" value:self.clientID],
                                              [NSURLQueryItem queryItemWithName:@"token" value:credential.accessToken]];
    
    NSString *clientSecret = self.clientSecret;
    if (clientSecret)
        parameters = [parameters arrayByAddingObject:[NSURLQueryItem queryItemWithName:@"client_secret" value:clientSecret]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.box.com/oauth2/revoke"]];
    [request setHTTPMethod:@"POST"];
    [request wfo_setBodyWithQueryItems:parameters];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable __unused data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (completionHandler)
            completionHandler([[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode], error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END
