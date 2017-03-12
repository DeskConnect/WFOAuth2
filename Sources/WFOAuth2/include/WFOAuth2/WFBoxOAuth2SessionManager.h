//
//  WFBoxOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/7/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_IOS
@class WFBoxAppAuthorizationSession;
#endif

typedef NSString *WFBoxOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
extern WFBoxOAuth2Scope const WFBoxReadWriteScope;
extern WFBoxOAuth2Scope const WFBoxManageEnterpriseScope;
extern WFBoxOAuth2Scope const WFBoxManageManagedUsersScope;
extern WFBoxOAuth2Scope const WFBoxManageGroupsScope;
extern WFBoxOAuth2Scope const WFBoxManagePropertiesScope;
extern WFBoxOAuth2Scope const WFBoxManageDataRetentionScope;
extern WFBoxOAuth2Scope const WFBoxManageAppUsersScope;
extern WFBoxOAuth2Scope const WFBoxManageWebhooksScope;

@interface WFBoxOAuth2SessionManager : WFOAuth2SessionManager<WFBoxOAuth2Scope> <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

#if TARGET_OS_IOS
- (WFBoxAppAuthorizationSession *)appAuthorizationSessionWithAppName:(NSString *)name
                                                         redirectURI:(nullable NSURL *)redirectURI
                                                   completionHandler:(WFOAuth2AuthenticationHandler)completionHandler;
#endif

- (void)authenticateWithScopes:(nullable NSArray<WFBoxOAuth2Scope> *)scopes
             completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFBoxOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
