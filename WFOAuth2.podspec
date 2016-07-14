Pod::Spec.new do |s|
  s.name         = "WFOAuth2"
  s.version      = "0.1.0"
  s.summary      = "WFOAuth2 is an extensible OAuth 2 library for macOS, iOS, tvOS and watchOS"

  s.description  = <<-DESC
  WFOAuth2 is an extensible OAuth 2 library for macOS, iOS, tvOS and watchOS. It aims to simplify authenticating your app with a variety of services.
                   DESC

  s.homepage     = "https://github.com/DeskConnect/WFOAuth2"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Conrad Kramer" => "ckrames1234@gmail.com" }
  s.social_media_url   = "https://twitter.com/conradev"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/DeskConnect/WFOAuth2.git", :tag => "#{s.version}" }

  s.source_files  = "Sources/WFOAuth2/*.m", "Sources/WFOAuth2/include/WFOAuth2/*.h"
  s.public_header_files = "Sources/WFOAuth2/include/WFOAuth2/*.h"
  s.framework  = "Foundation"
  s.requires_arc = true
end
