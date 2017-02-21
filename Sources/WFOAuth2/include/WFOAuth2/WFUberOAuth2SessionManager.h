//
//  WFUberOAuth2SessionManager.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/27/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2RevocableSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *WFUberOAuth2Scope NS_EXTENSIBLE_STRING_ENUM;
WFO_EXTERN WFUberOAuth2Scope const WFUberUserProfileScope;
WFO_EXTERN WFUberOAuth2Scope const WFUberUserHistoryScope;
WFO_EXTERN WFUberOAuth2Scope const WFUberUserHistoryLiteScope;
WFO_EXTERN WFUberOAuth2Scope const WFUberUserPlacesScope;
WFO_EXTERN WFUberOAuth2Scope const WFUberRequestRideScope;
WFO_EXTERN WFUberOAuth2Scope const WFUberRequestReceiptScope;
WFO_EXTERN WFUberOAuth2Scope const WFUberAllTripsScope;

@interface WFUberOAuth2SessionManager : WFOAuth2SessionManager<WFUberOAuth2Scope> <WFOAuth2RevocableSessionManager>

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(nullable NSString *)clientSecret;

- (instancetype)initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration
                                    clientID:(NSString *)clientID
                                clientSecret:(nullable NSString *)clientSecret;

- (void)authenticateWithScope:(nullable NSString *)scope
            completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

- (void)authenticateWithUsername:(NSString *)username
                        password:(NSString *)password
                           scope:(nullable NSString *)scope
               completionHandler:(WFOAuth2AuthenticationHandler)completionHandler NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
