//
//  NSURL+WFOAuth2.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 2/17/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/NSURL+WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

@implementation NSURL (WFOAuth2)

- (NSURL *)wfo_URLByAppendingQueryItems:(nullable NSArray<NSURLQueryItem *> *)queryItems {
    if (!queryItems.count)
        return self;
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
    components.queryItems = (components.queryItems ? [components.queryItems arrayByAddingObjectsFromArray:queryItems] : queryItems);
    return components.URL;
}

- (NSURLComponents *)wfo_normalizedURLComponents {
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.absoluteURL resolvingAgainstBaseURL:NO];
    components.query = nil;
    components.fragment = nil;
    if ([components.path hasSuffix:@"/"])
        components.path = [components.path substringToIndex:(components.path.length - 1)];
    
    return components;
}

- (BOOL)wfo_isEqualToRedirectURI:(nullable NSURL *)redirectURI {
    if (!redirectURI)
        return NO;
    
    return [[self wfo_normalizedURLComponents] isEqual:[redirectURI wfo_normalizedURLComponents]];
}

@end

NS_ASSUME_NONNULL_END
