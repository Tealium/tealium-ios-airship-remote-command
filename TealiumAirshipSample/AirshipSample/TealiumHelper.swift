//
//  TealiumHelper.swift
//
//  Created by Christina S on 6/18/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import TealiumSwift
import TealiumAirship


enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "airship-demo"
    static let environment = "prod"
}

class TealiumHelper {

    static let shared = TealiumHelper()

    let config = TealiumConfig(account: TealiumConfiguration.account,
                               profile: TealiumConfiguration.profile,
                               environment: TealiumConfiguration.environment)

    var tealium: Tealium?

    private init() {
        config.logLevel = .verbose
        config.shouldUseRemotePublishSettings = false
        config.remoteAPIEnabled = true
        tealium = Tealium(config: config,
                          enableCompletion: { [weak self] _ in
                              guard let self = self else { return }
                              guard let remoteCommands = self.tealium?.remoteCommands() else {
                                  return
                              }
                            self.tealium?.consentManager()?.setUserConsentStatus(.consented)
                            // MARK: Airship
                            let airshipCommand = AirshipRemoteCommand().remoteCommand()
//                            let adobeAnalyticsRemoteCommand = AdobeAnalyticsRemoteCommand().remoteCommand()
                            remoteCommands.add(airshipCommand)
                          })

    }


    public func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.track(title: title, data: data, completion: nil)
    }

    class func trackEvent(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.track(title: title, data: data, completion: nil)
    }

}
