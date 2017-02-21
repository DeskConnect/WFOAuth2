//
//  WFLyftOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFLyftOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
WFO_EXTERN WFLyftOAuth2Scope const WFLyftPublicScope;
WFO_EXTERN WFLyftOAuth2Scope const WFLyftReadRidesScope;
WFO_EXTERN WFLyftOAuth2Scope const WFLyftRequestRidesScope;
WFO_EXTERN WFLyftOAuth2Scope const WFLyftProfileScope;
WFO_EXTERN WFLyftOAuth2Scope const WFLyftOfflineScope;

@interface WFLyftOAuth2SessionManager : WFOAuth2SessionManager<WFLyftOAuth2Scope> <WFOAuth2RevocableSessionManager>

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret;

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                          scopes:(nullable NSArray<WFLyftOAuth2Scope> *)scopes
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
