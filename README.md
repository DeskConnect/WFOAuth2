# WFOAuth2

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/WFOAuth2.svg)](https://img.shields.io/cocoapods/v/WFOAuth2.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)](https://github.com/Carthage/Carthage)
![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg) 
[![Platform](https://img.shields.io/cocoapods/p/WFOAuth2.svg?style=flat)](http://cocoadocs.org/docsets/WFOAuth2)

**WFOAuth2** is an extensible OAuth 2 library for macOS, iOS, tvOS and watchOS. It aims to simplify authenticating your app with a variety of services.

## Supported Services

<table>
  <tr><td><img src="https://s3.amazonaws.com/workflow-actions/icons/com.google.GoogleMobile@2x.png" alt="Google" width="29"/></td><td>Google</td></tr>
  <tr><td><img src="https://s3.amazonaws.com/workflow-actions/icons/com.zimride.instant@2x.png" alt="Lyft" width="29"/></td><td>Lyft</td></tr>
  <tr><td><img src="https://s3.amazonaws.com/workflow-actions/icons/com.tinyspeck.chatlyio@2x.png" alt="Slack" width="29"/></td><td>Slack</td></tr>
  <tr><td><img src="https://s3.amazonaws.com/workflow-actions/icons/com.squareup.square@2x.png" alt="Square" width="29"/></td><td>Square</td></tr>
  <tr><td><img src="https://s3.amazonaws.com/workflow-actions/icons/com.ubercab.UberClient@2x.png" alt="Uber" width="29"/></td><td>Uber</td></tr>
</table>

**...and more to come!**

## Usage

**WFOAuth2** is very straightforward to use. This is how you authenticate with Google, for example:

```objective-c
WFGoogleOAuth2SessionManager *sessionManager = [[WFGoogleOAuth2SessionManager alloc] initWithClientID:@"XXXX-yyyy.apps.googleusercontent.com"
                                                                                         clientSecret:nil];

NSURL *redirectURI = [NSURL URLWithString:WFGoogleNativeRedirectURIString];
WKWebView *webView = [sessionManager authorizationWebViewWithScope:WFGoogleProfileScope
                                                       redirectURI:redirectURI
                                                 completionHandler:^(WFOAuth2Credential *credential, NSError *error) {
                          NSLog(@"Token: %@", credential.accessToken);
                      }];
                      
// Display web view to user
```

## Installation

### Carthage

To integrate WFOAuth2 into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```
github "DeskConnect/WFOAuth2" ~> 0.1
```

### CocoaPods

To integrate WFOAuth2 into your Xcode project using [CocoaPods](https://cocoapods.org), specify it in your `Podfile`:

```
target 'MyApp' do
  pod 'WFOAuth2', '~> 0.1'
end
```

### Swift Package Manager

To integrate WFOAuth2 into your project using the [Swift Package Manager](https://swift.org/package-manager/), specify it in your `Package.swift` file:

``` swift
import PackageDescription

let package = Package(
    name: "MyApp",
    dependencies: [
  		.Package(url: "https://github.com/DeskConnect/WFOAuth2.git", majorVersion: 0, minor: 1),
    ]
)
```

## Contributing

If you are interested in contributing to WFOAuth2, check out the list of possible [enhancements](https://github.com/DeskConnect/WFOAuth2/labels/enhancement). We also want to add support for as many services as possible, so you could contribute a `WFOAuth2SessionManager` subclass for your favorite service.

## License

WFOAuth2 is available under the MIT license. See the [`LICENSE`](https://github.com/DeskConnect/WFOAuth2/blob/master/LICENSE) file for more info.
