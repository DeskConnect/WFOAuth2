//
//  LoginViewController.h
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/25/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WFOAuth2/WFOAuth2.h>

NS_ASSUME_NONNULL_BEGIN

@class LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)loginViewController:(LoginViewController *)loginViewController didAuthenticateWithCredential:(WFOAuth2Credential *)credential;
- (void)loginViewController:(LoginViewController *)loginViewController didFailWithError:(nullable NSError *)error;
- (void)loginViewControllerDidCancel:(LoginViewController *)loginViewController;
@end

@interface LoginViewController : UIViewController

@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@property (nonatomic, readonly) WFOAuth2ProviderSessionManager *sessionManager;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithSessionManager:(WFOAuth2ProviderSessionManager *)sessionManager scope:(nullable NSString *)scope redirectURI:(nullable NSURL *)redirectURI;

@end

NS_ASSUME_NONNULL_END
