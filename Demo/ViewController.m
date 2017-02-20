//
//  ViewController.m
//  WFOAuth2
//
//  Created by Conrad Kramer on 3/24/16.
//  Copyright © 2016-2017 DeskConnect, Inc. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
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
    WFOAuth2SessionManager *sessionManager = configuration.sessionManager;
    if (!sessionManager)
        return;
    
    if ([configuration.redirectURI.scheme isEqualToString:@"wfoauth2"] ||
        [configuration.redirectURI.scheme hasPrefix:@"com.googleusercontent"]) {
        __weak __typeof__(self) weakSelf = self;
        WFOAuth2AuthorizationSession *authorizationSession = [sessionManager authorizationSessionWithResponseType:WFOAuth2ResponseTypeCode scopes:configuration.scopes redirectURI:configuration.redirectURI completionHandler:^(WFOAuth2Credential * __nullable credential, NSError * __nullable error) {
            if (credential) {
                [weakSelf presentCredential:credential fromSessionManager:sessionManager];
            } else if (error) {
                [weakSelf presentError:error];
            }
        }];
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.currentSession = authorizationSession;
        
        SFSafariViewController *safariViewController = authorizationSession.safariViewController;
        [self presentViewController:safariViewController animated:YES completion:nil];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithSessionManager:sessionManager scopes:configuration.scopes redirectURI:configuration.redirectURI];
        loginViewController.delegate = self;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)presentError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:(error.localizedFailureReason ?: error.localizedDescription)
                                          preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)presentCredential:(WFOAuth2Credential *)credential
       fromSessionManager:(WFOAuth2SessionManager *)sessionManager {
    
    NSString *accessToken = credential.accessToken;
    if (accessToken.length > 10)
        accessToken = [[accessToken substringToIndex:10] stringByAppendingString:@"..."];
    
    NSString *refreshToken = credential.refreshToken;
    if (refreshToken.length > 10)
        refreshToken = [[refreshToken substringToIndex:10] stringByAppendingString:@"..."];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    NSString *expirationDate = (credential.expirationDate ? [dateFormatter stringFromDate:credential.expirationDate] : nil);
    
    NSMutableArray<NSString *> *message = [NSMutableArray new];
    if (accessToken)
        [message addObject:[NSString stringWithFormat:@"Access Token: %@", accessToken]];
    if (credential.tokenType)
        [message addObject:[NSString stringWithFormat:@"Token Type: %@", credential.tokenType]];
    if (refreshToken)
        [message addObject:[NSString stringWithFormat:@"Refresh Token: %@", refreshToken]];
    if (expirationDate)
        [message addObject:[NSString stringWithFormat:@"Expires: %@", expirationDate]];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Access Token"
                                          message:[message componentsJoinedByString:@"\n"]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    if (credential.refreshToken) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Refresh" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [sessionManager authenticateWithRefreshCredential:credential completionHandler:^(WFOAuth2Credential * __nullable credential, NSError * __nullable error) {
                if (credential)
                    [self presentCredential:credential fromSessionManager:sessionManager];
                else if (error)
                    [self presentError:error];
            }];
        }]];
    }
    
    if ([sessionManager conformsToProtocol:@protocol(WFOAuth2RevocableSessionManager)]) {
        id<WFOAuth2RevocableSessionManager> revocableSessionManager = (id<WFOAuth2RevocableSessionManager>)sessionManager;
        [alertController addAction:[UIAlertAction actionWithTitle:@"Revoke" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [revocableSessionManager revokeCredential:credential completionHandler:^(BOOL success, NSError * __nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error)
                        return [self presentError:error];
                    
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
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - LoginViewControllerDelegate

- (void)loginViewController:(LoginViewController *)loginViewController didAuthenticateWithCredential:(WFOAuth2Credential *)credential {
    [loginViewController dismissViewControllerAnimated:YES completion:^{
        [self presentCredential:credential fromSessionManager:loginViewController.sessionManager];
    }];
}

- (void)loginViewController:(LoginViewController *)loginViewController didFailWithError:(nullable NSError *)error {
    [loginViewController dismissViewControllerAnimated:YES completion:^{
        [self presentError:error];
    }];
}

- (void)loginViewControllerDidCancel:(LoginViewController *)loginViewController {
    [loginViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[[ProviderConfiguration allConfigurations] objectAtIndex:row] name];
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
