Pod::Spec.new do |s|

    # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    s.name         = "TealiumAirshipLocation"
    s.module_name  = "TealiumAirshipLocation"
    s.version      = "1.0.0"
    s.summary      = "Tealium Swift and Airship Location integration"
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

    # s.ios.dependency 'TealiumAirship/Core'
    s.ios.dependency 'Airship/Location', '~> 13.1.1'

end
