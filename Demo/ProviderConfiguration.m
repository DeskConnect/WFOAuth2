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
            [self newWithClass:[WFDropboxOAuth2SessionManager class] clientID:@"k3869owh4bj3zbt" clientSecret:@"49jy1mdm6o30w3t" scopes:nil redirectURI:[NSURL URLWithString:@"http://localhost"]],
            [self newWithClass:[WFGoogleOAuth2SessionManager class] clientID:@"266399808145-3avt9dudaqe71j6lr8haqigudqi91lf5.apps.googleusercontent.com" clientSecret:nil scopes:@[WFGoogleProfileScope] redirectURI:[NSURL URLWithString:@"com.googleusercontent.apps.266399808145-3avt9dudaqe71j6lr8haqigudqi91lf5:/callback"]],
            [self newWithClass:[WFImgurOAuth2SessionManager class] clientID:@"8e981b57b0b0b2d" clientSecret:@"fc27649022f33b364e100dcbeb2482be26ccd85e" scopes:nil redirectURI:[NSURL URLWithString:@"wfoauth2://callback"]],
            [self newWithClass:[WFLyftOAuth2SessionManager class] clientID:@"1v3Ec3XqBbqE" clientSecret:@"CD_IcdcyH3xdRsaflrd-roCiv1rVnJJX" scopes:@[WFLyftOfflineScope, WFLyftProfileScope] redirectURI:[NSURL URLWithString:@"wfoauth2://callback"]],
            [self newWithClass:[WFSlackOAuth2SessionManager class] clientID:@"3214730525.4155085303" clientSecret:@"bac7521cf39042b46b35978b045d5ea0" scopes:@[WFSlackChannelWriteScope] redirectURI:[NSURL URLWithString:@"wfoauth2://callback"]],
            [self newWithClass:[WFSquareOAuth2SessionManager class] clientID:nil clientSecret:nil scopes:nil redirectURI:nil],
            [self newWithClass:[WFTodoistOAuth2SessionManager class] clientID:@"171d4959668b49a5b1c6b0b8990d6983" clientSecret:@"5cb9ed8e20f34b5a9936594ba6b98b7b" scopes:@[WFTodoistReadWriteDataScope, WFTodoistDeleteDataScope] redirectURI:[NSURL URLWithString:@"http://localhost"]],
            [self newWithClass:[WFUberOAuth2SessionManager class] clientID:@"FVZC8i9VfAn2DIi0TdBG0-I5T7RcU3_j" clientSecret:nil scopes:@[WFUberUserProfileScope] redirectURI:[NSURL URLWithString:@"https://localhost"]],
            [self newWithClass:[WFWunderlistOAuth2SessionManager class] clientID:@"a5630c85fc7ee949385a" clientSecret:@"28a1b2df54b3cf8e9ed395730cda6a6db6712bcbd1abfe2924ef069a012a" scopes:nil redirectURI:[NSURL URLWithString:@"https://localhost"]],
        ];
    });
    return allConfigurations;
}

+ (instancetype)newWithClass:(Class)managerClass
                    clientID:(nullable NSString *)clientID
                clientSecret:(nullable NSString *)clientSecret
                      scopes:(nullable NSArray<NSString *> *)scopes
                 redirectURI:(nullable NSURL *)redirectURI {
    return [[self alloc] initWithClass:managerClass
                              clientID:clientID
                          clientSecret:clientSecret
                                scopes:scopes
                           redirectURI:redirectURI];
}

- (instancetype)initWithClass:(Class)managerClass
                     clientID:(nullable NSString *)clientID
                 clientSecret:(nullable NSString *)clientSecret
                       scopes:(nullable NSArray<NSString *> *)scopes
                  redirectURI:(nullable NSURL *)redirectURI {
    NSParameterAssert(managerClass);
    self = [super init];
    if (!self)
        return nil;
    
    _managerClass = managerClass;
    _clientID = clientID;
    _clientSecret = clientSecret;
    _scopes = scopes;
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

- (nullable WFOAuth2SessionManager *)sessionManager {
    if (!_clientID)
        return nil;
    
    return [[_managerClass alloc] initWithClientID:_clientID clientSecret:_clientSecret];
}

@end

NS_ASSUME_NONNULL_END
