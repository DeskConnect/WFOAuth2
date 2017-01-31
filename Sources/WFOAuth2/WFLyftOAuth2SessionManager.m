//
//  WFLyftOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManagerSubclass.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

#import <WFOAuth2/WFLyftOAuth2SessionManager.h>

NSString * const WFLyftPublicScope = @"public";
NSString * const WFLyftReadRidesScope = @"rides.read";
NSString * const WFLyftRequestRidesScope = @"rides.request";
NSString * const WFLyftProfileScope = @"profile";
NSString * const WFLyftOfflineScope = @"offline";

@implementation WFLyftOAuth2SessionManager

+ (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://api.lyft.com/oauth"];
}

+ (BOOL)basicAuthEnabled {
    return YES;
}

+ (NSURL *)authorizationURL {
    return [NSURL URLWithString:@"https://api.lyft.com/oauth/authorize"];
}

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL success, NSError * __nullable error))completionHandler {
    NSParameterAssert(credential);
    
    NSURL *url = [[[self class] baseURL] URLByAppendingPathComponent:@"revoke_refresh_token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request wfo_setAuthorizationWithUsername:self.clientID password:self.clientSecret];

    NSMutableArray<NSURLQueryItem *> *parameters = [NSMutableArray new];
    if (credential.refreshToken)
        [parameters addObject:[NSURLQueryItem queryItemWithName:@"token" value:credential.refreshToken]];
    [request wfo_setBodyWithQueryItems:parameters];

    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (data.length) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            error = (WFRFC6749Section5_2ErrorFromResponse(responseObject) ?: error);
        }
        
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (completionHandler)
            completionHandler([[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode], error);
    }] resume];
}

@end
