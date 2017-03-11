//
//  WFOAuth2WebAuthorizationSessionPrivate.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2WebAuthorizationSession.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2WebAuthorizationSession ()

@property (nonatomic, readonly) NSString *responseKey;

- (BOOL)resumeSessionWithResponseObject:(NSDictionary<NSString *, NSString *> *)responseObject;

@end

NS_ASSUME_NONNULL_END
