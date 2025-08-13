//
//  TealiumHelper.swift
//
//  Created by Christina S on 6/18/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import TealiumSwift
import TealiumAirship
import UIKit

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "airship-demo"
    static let environment = "dev"
}

class TealiumHelper {

    static let shared = TealiumHelper()
    
    private init() {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.remoteAPIEnabled = true
        config.logLevel = .info
        config.collectors = [Collectors.Lifecycle]
        config.dispatchers = [
            //Dispatchers.TagManagement,
            Dispatchers.RemoteCommands
        ]
    }

    let config = TealiumConfig(account: TealiumConfiguration.account,
                               profile: TealiumConfiguration.profile,
                               environment: TealiumConfiguration.environment)

    var tealium: Tealium?
    
    // JSON Remote Command
    var airshipRemoteCommand: AirshipRemoteCommand?
    
    func configure(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        airshipRemoteCommand = AirshipRemoteCommand(
            type: .local(file: "airship", bundle: Bundle.main),
            launchOptions: launchOptions
        )
        
        airshipRemoteCommand?.onReady {
            print("🚀 Airship is ready!")
        }
        
        config.addRemoteCommand(airshipRemoteCommand!)
        
        tealium = Tealium(config: config)
    }

    class func trackView(title: String, data: [String: Any]?) {
        let tealiumView = TealiumView(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumView)
    }
    
    class func trackEvent(title: String, data: [String: Any]?) {
        let tealiumEvent = TealiumEvent(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumEvent)
    }

}
