Pod::Spec.new do |s|

    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.name         = "TealiumAirship"
    s.module_name  = "TealiumAirship"
    s.version      = "1.0.0"
    s.summary      = "Tealium Swift and Airship integration"
    s.description  = <<-DESC
    Tealium's integration with Airship for iOS.
    DESC
    s.homepage     = "https://github.com/Tealium/tealium-ios-airship-remote-command"

    # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.license      = { :type => "Commercial", :file => "LICENSE.txt" }
    
    # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.authors            = { "Tealium Inc." => "tealium@tealium.com",
        "craigrouse"   => "craig.rouse@tealium.com"}
    s.social_media_url   = "https://twitter.com/tealium"

    # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.swift_version = "5.0"
    s.platform     = :ios, "11.0"
    s.ios.deployment_target = "11.0"    

    # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.source       = { :git => "https://github.com/Tealium/tealium-ios-airship-remote-command.git", :tag => "#{s.version}" }

    # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.source_files      = "Sources/**/*.{swift}"
    s.ios.exclude_files     = "Sources/Location/*"
    # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.ios.dependency 'tealium-swift/Core', '~> 2.3'
    s.ios.dependency 'tealium-swift/RemoteCommands', '~> 2.3'
    s.ios.dependency 'tealium-swift/TagManagement', '~> 2.3'
    s.ios.dependency 'Airship', '~> 16.0.1'
    s.ios.dependency 'Airship/Location', '~> 16.0.1'

end
