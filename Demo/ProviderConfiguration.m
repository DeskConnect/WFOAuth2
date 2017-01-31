//
//  ProviderConfiguration.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/30/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import "ProviderConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProviderConfiguration ()

@property (nonatomic, readonly) Class managerClass;
@property (nonatomic, readonly, nullable) NSString *clientID;
@property (nonatomic, readonly, nullable) NSString *clientSecret;

@end

@implementation ProviderConfiguration

+ (NSArray<ProviderConfiguration *> *)allConfigurations {
    static NSArray<ProviderConfiguration *> *allConfigurations = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allConfigurations = @[
            [self newWithClass:[WFDropboxOAuth2SessionManager class] clientID:@"k3869owh4bj3zbt" clientSecret:@"49jy1mdm6o30w3t" scope:nil redirectURI:[NSURL URLWithString:@"http://localhost"]],
            [self newWithClass:[WFGoogleOAuth2SessionManager class] clientID:@"266399808145-3avt9dudaqe71j6lr8haqigudqi91lf5.apps.googleusercontent.com" clientSecret:nil scope:WFGoogleProfileScope redirectURI:[NSURL URLWithString:WFGoogleNativeRedirectURIString]],
            [self newWithClass:[WFLyftOAuth2SessionManager class] clientID:@"1v3Ec3XqBbqE" clientSecret:@"CD_IcdcyH3xdRsaflrd-roCiv1rVnJJX" scope:[@[WFLyftOfflineScope, WFLyftProfileScope] componentsJoinedByString:@" "] redirectURI:[NSURL URLWithString:@"http://localhost"]],
            [self newWithClass:[WFSlackOAuth2SessionManager class] clientID:@"3214730525.4155085303" clientSecret:@"bac7521cf39042b46b35978b045d5ea0" scope:WFSlackChannelWriteScope redirectURI:[NSURL URLWithString:@"https://localhost"]],
            [self newWithClass:[WFSquareOAuth2SessionManager class] clientID:nil clientSecret:nil scope:nil redirectURI:nil],
            [self newWithClass:[WFUberOAuth2SessionManager class] clientID:@"FVZC8i9VfAn2DIi0TdBG0-I5T7RcU3_j" clientSecret:nil scope:WFUberUserProfileScope redirectURI:[NSURL URLWithString:@"https://localhost"]],
        ];
    });
    return allConfigurations;
}

+ (instancetype)newWithClass:(Class)managerClass
                    clientID:(nullable NSString *)clientID
                clientSecret:(nullable NSString *)clientSecret
                       scope:(nullable NSString *)scope
                 redirectURI:(nullable NSURL *)redirectURI {
    return [[self alloc] initWithClass:managerClass
                              clientID:clientID
                          clientSecret:clientSecret
                                 scope:scope
                           redirectURI:redirectURI];
}

- (instancetype)initWithClass:(Class)managerClass
                     clientID:(nullable NSString *)clientID
                 clientSecret:(nullable NSString *)clientSecret
                        scope:(nullable NSString *)scope
                  redirectURI:(nullable NSURL *)redirectURI {
    NSParameterAssert(managerClass);
    self = [super init];
    if (!self)
        return nil;
    
    _managerClass = managerClass;
    _clientID = clientID;
    _clientSecret = clientSecret;
    _scope = scope;
    _redirectURI = redirectURI;
    
    return self;
}

- (NSString *)name {
    NSMutableString *name = [NSStringFromClass(_managerClass) mutableCopy];
    [name replaceOccurrencesOfString:@"WF" withString:@"" options:0 range:NSMakeRange(0, 2)];
    [name replaceOccurrencesOfString:@"OAuth2SessionManager" withString:@"" options:0 range:NSMakeRange(name.length - 20, 20)];
    return name;
}

- (BOOL)isValid {
    return !!self.sessionManager;
}

- (nullable WFOAuth2ProviderSessionManager *)sessionManager {
    if (!_clientID)
        return nil;
    
    return [[_managerClass alloc] initWithClientID:_clientID clientSecret:_clientSecret];
}

@end

NS_ASSUME_NONNULL_END
