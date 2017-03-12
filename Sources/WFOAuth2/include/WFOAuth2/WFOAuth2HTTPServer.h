//
//  WFOAuth2HTTPServer.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/8/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2WebAuthorizationSession.h>

#if !TARGET_OS_WATCH

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2HTTPServer : NSObject

@property (nonatomic, readonly) NSURL *redirectURI;

- (nullable instancetype)init NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#endif
