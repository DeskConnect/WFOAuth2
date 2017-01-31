//
//  ViewController.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "ProviderConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource, LoginViewControllerDelegate>

@property (nonatomic, readonly, weak) UIButton *loginButton;
@property (nonatomic, readonly, weak) UIPickerView *pickerView;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    UIView *view = self.view;
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginButton];
    _loginButton = loginButton;
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [view addSubview:pickerView];
    _pickerView = pickerView;
    
    [NSLayoutConstraint activateConstraints:@[
        [loginButton.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [NSLayoutConstraint constraintWithItem:loginButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:0.5f constant:0.0f],
        [pickerView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
        [pickerView.leftAnchor constraintEqualToAnchor:view.leftAnchor],
        [pickerView.rightAnchor constraintEqualToAnchor:view.rightAnchor],
    ]];
    
    [self pickerView:pickerView didSelectRow:0 inComponent:0];
}

- (void)loginPressed {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    if (row == -1)
        return;
    
    ProviderConfiguration *configuration = [[ProviderConfiguration allConfigurations] objectAtIndex:row];
    WFOAuth2SessionManager<WFOAuth2ProviderSessionManager> *sessionManager = configuration.sessionManager;
    if (!sessionManager)
        return;

    LoginViewController *loginViewController = [[LoginViewController alloc] initWithSessionManager:sessionManager scope:configuration.scope redirectURI:configuration.redirectURI];
    loginViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewController:(LoginViewController *)loginViewController didAuthenticateWithCredential:(WFOAuth2Credential *)credential {
    [loginViewController dismissViewControllerAnimated:YES completion:^{
        WFOAuth2SessionManager<WFOAuth2ProviderSessionManager> *sessionManager = loginViewController.sessionManager;
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Access Token"
                                              message:credential.accessToken
                                              preferredStyle:UIAlertControllerStyleAlert];
        if ([sessionManager conformsToProtocol:@protocol(WFOAuth2RevocableSessionManager)]) {
            WFOAuth2SessionManager<WFOAuth2RevocableSessionManager> *revocableSessionManager = (WFOAuth2SessionManager<WFOAuth2RevocableSessionManager> * )sessionManager;
            [alertController addAction:[UIAlertAction actionWithTitle:@"Revoke" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [revocableSessionManager revokeCredential:credential completionHandler:^(BOOL success, NSError * __nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString *title = (success ? @"Revocation Succeeded" : @"Revocation Failed");
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:title
                                                              message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        
                        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }];
            }]];
        } else {
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        }
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)loginViewController:(LoginViewController *)loginViewController didFailWithError:(nullable NSError *)error {
    [loginViewController dismissViewControllerAnimated:YES completion:^{
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:error.localizedDescription
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)loginViewControllerDidCancel:(LoginViewController *)loginViewController {
    [loginViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ProviderConfiguration *configuration = [[ProviderConfiguration allConfigurations] objectAtIndex:row];
    return configuration.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    ProviderConfiguration *configuration = [[ProviderConfiguration allConfigurations] objectAtIndex:row];
    
    UIButton *loginButton = self.loginButton;
    loginButton.enabled = configuration.valid;
    [loginButton setTitle:[NSString stringWithFormat:@"Login with %@", configuration.name] forState:UIControlStateNormal];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[ProviderConfiguration allConfigurations] count];
}

@end

NS_ASSUME_NONNULL_END
