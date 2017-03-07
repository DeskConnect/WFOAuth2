//
//  NSURL+WFOAuth2.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (WFOAuth2)

- (NSURL *)wfo_URLByAppendingQueryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems;

- (BOOL)wfo_isEqualToRedirectURI:(nullable NSURL *)redirectURI;

@end

NS_ASSUME_NONNULL_END
