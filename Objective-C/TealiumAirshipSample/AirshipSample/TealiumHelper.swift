//
//  TealiumHelper.swift
//
//  Created by Christina S on 6/18/19.
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import TealiumIOS


enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "airship-demo"
    static let environment = "dev"
}

class TealiumHelper {

    static let shared = TealiumHelper()

    let config = TEALConfiguration(account: TealiumConfiguration.account,
                               profile: TealiumConfiguration.profile,
                               environment: TealiumConfiguration.environment)

    var tealium: Tealium?
    var remoteCommand = AirshipRemoteCommand()
    
    private init() {
        config.setRemoteCommandsEnabled(true)
        config.logLevel = .dev
        tealium = Tealium.newInstance(forKey: "airshipdemo", configuration: config)
        let queue = DispatchQueue(label: "com.tealium.airshipdemo", qos: .utility, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global(qos: .utility))
        tealium?.addRemoteCommandID("airship", description: "Airship", targetQueue: queue, responseBlock: remoteCommand.remoteCommand())
    }


    public func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.trackView(withTitle: title, dataSources: data)
    }

    class func trackEvent(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.trackEvent(withTitle: title, dataSources: data)
    }

}
