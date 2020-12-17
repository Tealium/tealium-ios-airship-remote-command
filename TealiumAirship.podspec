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
    s.platform     = :ios, "10.0"
    s.ios.deployment_target = "10.0"    

    # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.source       = { :git => "https://github.com/Tealium/tealium-ios-airship-remote-command.git", :tag => "#{s.version}" }

    s.default_subspec = "Core"

    s.subspec "Core" do |core|
        # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
        core.ios.source_files      = "Sources/**/*.{swift}"
        core.ios.exclude_files     = "Sources/Location/*"
        # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
        core.ios.dependency 'tealium-swift/Core'
        core.ios.dependency 'tealium-swift/RemoteCommands'
        core.ios.dependency 'tealium-swift/TagManagement'
        core.ios.dependency 'Airship', '~> 14.1'
    end

    s.subspec "Location" do |location|
       # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
        location.ios.source_files      = "Sources/Location/*.{swift}"
        # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
        location.ios.dependency 'TealiumAirship/Core'
        location.ios.dependency 'Airship/Location', '~> 14.1'
    end

end
