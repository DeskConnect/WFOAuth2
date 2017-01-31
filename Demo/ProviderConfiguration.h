//
//  ProviderConfiguration.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/30/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProviderConfiguration : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly, getter=isValid) BOOL valid;
@property (nonatomic, readonly) WFOAuth2SessionManager<WFOAuth2ProviderSessionManager> *sessionManager;

@property (nonatomic, readonly, nullable) NSString *scope;
@property (nonatomic, readonly, nullable) NSURL *redirectURI;

+ (NSArray<ProviderConfiguration *> *)allConfigurations;

@end

NS_ASSUME_NONNULL_END
