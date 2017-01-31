//
//  WFOAuth2Credential.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/22/15.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2Credential.h>

NS_ASSUME_NONNULL_BEGIN

static inline __nullable id WFEnforceClass(id __nullable obj, Class objectClass) {
    return ([obj isKindOfClass:objectClass] ? obj : nil);
}

@implementation WFOAuth2Credential

- (nullable instancetype)initWithResponseObject:(nullable NSDictionary<NSString *, id<NSCopying>> *)responseObject {
    self = [super init];
    if (!self)
        return nil;
    
    _accessToken = (NSString * __nonnull)[WFEnforceClass(responseObject[@"access_token"], [NSString class]) copy];
    if (!_accessToken.length)
        return nil;
    
    // Some servers don't specify a token type
    _tokenType = ([WFEnforceClass(responseObject[@"token_type"], [NSString class]) copy] ?: @"bearer");
    
    _refreshToken = [WFEnforceClass(responseObject[@"refresh_token"], [NSString class]) copy];
    
    NSNumber *expiresIn = WFEnforceClass(responseObject[@"expires_in"], [NSNumber class]);
    _expirationDate = (expiresIn ? [NSDate dateWithTimeIntervalSinceNow:expiresIn.doubleValue] : nil);
    
    return self;
}

- (BOOL)isValid {
    return (self.refreshToken || (self.accessToken && !self.expired));
}

- (BOOL)isExpired {
    return (self.expirationDate.timeIntervalSinceNow > 0.0f);
}

#pragma mark - NSObject

- (BOOL)isEqual:(WFOAuth2Credential *)object {
    if (self == object)
        return YES;
    
    if (![object isKindOfClass:[self class]])
        return NO;
    
    return ([_accessToken isEqualToString:object.accessToken] &&
            [_tokenType compare:object.tokenType options:NSCaseInsensitiveSearch] == NSOrderedSame &&
            ((_refreshToken == object.refreshToken) || [_refreshToken isEqualToString:object.refreshToken]) &&
            ((_expirationDate == object.expirationDate) || [_expirationDate isEqualToDate:object.expirationDate]));
}

- (NSUInteger)hash {
    return (_accessToken.hash ^ _refreshToken.hash ^ _expirationDate.hash);
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone * __unused)zone {
    return self;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self)
        return nil;
    
    _accessToken = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(accessToken))];
    if (!_accessToken.length)
        return nil;
    
    _tokenType = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(tokenType))];
    _refreshToken = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(refreshToken))];
    _expirationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(expirationDate))];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:NSStringFromSelector(@selector(accessToken))];
    [aCoder encodeObject:self.tokenType forKey:NSStringFromSelector(@selector(tokenType))];
    [aCoder encodeObject:self.refreshToken forKey:NSStringFromSelector(@selector(refreshToken))];
    [aCoder encodeObject:self.expirationDate forKey:NSStringFromSelector(@selector(expirationDate))];
}

@end

NS_ASSUME_NONNULL_END
