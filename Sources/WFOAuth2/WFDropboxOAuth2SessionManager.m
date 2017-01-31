//
//  WFDropboxOAuth2SessionManager.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 1/31/17.
//  Copyright © 2017 DeskConnect, Inc. All rights reserved.
//

#import <WFOAuth2/WFOAuth2ProviderSessionManagerSubclass.h>
#import <WFOAuth2/NSMutableURLRequest+WFOAuth2.h>
#import <WFOAuth2/WFOAuth2Error.h>

#import <WFOAuth2/WFDropboxOAuth2SessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@implementation WFDropboxOAuth2SessionManager

+ (NSURL *)baseURL {
    return [NSURL URLWithString:@"https://api.dropboxapi.com/1/oauth2"];
}

+ (NSURL *)authorizationURL {
    return [NSURL URLWithString:@"https://www.dropbox.com/1/oauth2/authorize"];
}

#pragma mark - WFOAuth2RevocableSessionManager

- (void)revokeCredential:(WFOAuth2Credential *)credential
       completionHandler:(void (^__nullable)(BOOL, NSError * __nullable))completionHandler {
    NSParameterAssert(credential);
    
    NSURL *url = [NSURL URLWithString:@"https://api.dropboxapi.com/1/disable_access_token"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request wfo_setAuthorizationWithCredential:credential];
    
    [[self.session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        BOOL success = [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)] containsIndex:statusCode];
        if (data.length) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            success = !responseObject.count;
            error = (WFRFC6749Section5_2ErrorFromResponse(responseObject) ?: error);
        }
        
        if (completionHandler)
            completionHandler(success, error);
    }] resume];
}

@end

NS_ASSUME_NONNULL_END