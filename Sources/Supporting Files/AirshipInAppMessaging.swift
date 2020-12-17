//
//  AirshipInAppMessaging.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import Airship

extension AirshipInstance {

    public var inAppMessagingEnabled: Bool? {
        get {
            UAInAppAutomation.shared()?.isEnabled
        }

        set {
            guard let enabled = newValue else {
                return
            }
            UAInAppAutomation.shared()?.isEnabled = enabled
        }
    }

    public var inAppMessagingPaused: Bool? {
        get {
            UAInAppAutomation.shared()?.isPaused
        }

        set {
            guard
            let paused = newValue
            else {
                return
            }
            UAInAppAutomation.shared()?.isPaused = paused
        }
    }

    public var inAppMessagingDisplayInterval: String? {
        get {
            UAInAppAutomation.shared()?.inAppMessageManager.displayInterval.description
        }

        set {
            guard let intervalString = newValue,
                let interval = TimeInterval(intervalString) else {
                return
            }
            UAInAppAutomation.shared()?.inAppMessageManager.displayInterval = interval
        }
    }

}
