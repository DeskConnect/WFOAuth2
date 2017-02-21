//
//  WFLyftOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2ProviderSessionManager.h>
#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFLyftOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
extern WFLyftOAuth2Scope const WFLyftPublicScope;
extern WFLyftOAuth2Scope const WFLyftReadRidesScope;
extern WFLyftOAuth2Scope const WFLyftRequestRidesScope;
extern WFLyftOAuth2Scope const WFLyftProfileScope;
extern WFLyftOAuth2Scope const WFLyftOfflineScope;

@interface WFLyftOAuth2SessionManager : WFOAuth2SessionManager<WFLyftOAuth2Scope> <WFOAuth2ProviderSessionManager, WFOAuth2RevocableSessionManager>

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFLyftOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
