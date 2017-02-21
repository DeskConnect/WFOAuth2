//
//  WFTodoistOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/21/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFTodoistOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
extern WFTodoistOAuth2Scope const WFTodoistAddTaskScope;
extern WFTodoistOAuth2Scope const WFTodoistReadDataScope;
extern WFTodoistOAuth2Scope const WFTodoistReadWriteDataScope;
extern WFTodoistOAuth2Scope const WFTodoistDeleteDataScope;
extern WFTodoistOAuth2Scope const WFTodoistDeleteProjectScope;

@interface WFTodoistOAuth2SessionManager : WFOAuth2SessionManager<WFTodoistOAuth2Scope> <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFTodoistOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithRefreshCredential:(WFOAuth2Credential *)refreshCredential
                        completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
