//
//  ViewController.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016 DeskConnect, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewController () <LoginViewControllerDelegate>

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *googleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    googleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [googleButton setTitle:@"Login to Google" forState:UIControlStateNormal];
    [googleButton addTarget:self action:@selector(googlePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:googleButton];
   
    UIButton *slackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    slackButton.translatesAutoresizingMaskIntoConstraints = NO;
    [slackButton setTitle:@"Login to Slack" forState:UIControlStateNormal];
    [slackButton addTarget:self action:@selector(slackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:slackButton];
    
    UIButton *uberButton = [UIButton buttonWithType:UIButtonTypeSystem];
    uberButton.translatesAutoresizingMaskIntoConstraints = NO;
    [uberButton setTitle:@"Login to Uber" forState:UIControlStateNormal];
    [uberButton addTarget:self action:@selector(uberPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uberButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:googleButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:googleButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:0.8f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:slackButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:slackButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:uberButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:uberButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.2f constant:0.0f]];
}

- (void)googlePressed:(nullable id)sender {
    WFGoogleOAuth2SessionManager *sessionManager = [[WFGoogleOAuth2SessionManager alloc] initWithClientID:@"266399808145-3avt9dudaqe71j6lr8haqigudqi91lf5.apps.googleusercontent.com" clientSecret:nil];
    [self loginWithSessionManager:sessionManager scope:WFGoogleProfileScope redirectURI:[NSURL URLWithString:WFGoogleNativeRedirectURIString]];
}

- (void)slackPressed:(nullable id)sender {
    WFSlackOAuth2SessionManager *sessionManager = [[WFSlackOAuth2SessionManager alloc] initWithClientID:@"3214730525.4155085303" clientSecret:@"bac7521cf39042b46b35978b045d5ea0"];
    [self loginWithSessionManager:sessionManager scope:WFSlackChannelWriteScope redirectURI:[NSURL URLWithString:@"https://localhost"]];
}

- (void)uberPressed:(nullable id)sender {
    WFUberOAuth2SessionManager *sessionManager = [[WFUberOAuth2SessionManager alloc] initWithClientID:@"FVZC8i9VfAn2DIi0TdBG0-I5T7RcU3_j" clientSecret:@"8mj8sI-liVAmhSe8duMGQO2SKqPAnGeMDgzuUXyB"];
    [self loginWithSessionManager:sessionManager scope:WFUberUserProfileScope redirectURI:[NSURL URLWithString:@"https://localhost"]];
}

- (void)loginWithSessionManager:(WFOAuth2SessionManager<WFOAuth2ProviderSessionManager> *)sessionManager scope:(nullable NSString *)scope redirectURI:(nullable NSURL *)redirectURI {
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithSessionManager:sessionManager scope:scope redirectURI:redirectURI];
    loginViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)loginViewController:(LoginViewController *)loginViewController didAuthenticateWithCredential:(WFOAuth2Credential *)credential {
    [loginViewController dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Access Token" message:credential.accessToken preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)loginViewController:(LoginViewController *)loginViewController didFailWithError:(nullable NSError *)error {
    [loginViewController dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)loginViewControllerDidCancel:(LoginViewController *)loginViewController {
    [loginViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

NS_ASSUME_NONNULL_END
