//
//  WFOAuth2SessionManagerPrivate.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2SessionManager.h>
#import <WFOAuth2/WFOAuth2Defines.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFOAuth2SessionManager ()

/**
 The managed session. This property should only be referenced by subclasses.
 */
@property (nonatomic, readonly, strong) NSURLSession *session;

@end

NS_ASSUME_NONNULL_END
