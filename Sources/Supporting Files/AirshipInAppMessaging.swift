//
//  AirshipInAppMessaging.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
import AirshipKit
#else
import AirshipCore
import AirshipAutomation
#endif

extension AirshipInstance {

    public var inAppMessagingEnabled: Bool? {
        get {
            InAppAutomation.shared.isComponentEnabled
        }

        set {
            guard let enabled = newValue else {
                return
            }
            InAppAutomation.shared.isComponentEnabled = enabled
        }
    }

    public var inAppMessagingPaused: Bool? {
        get {
            InAppAutomation.shared.isPaused
        }

        set {
            guard
            let paused = newValue
            else {
                return
            }
            InAppAutomation.shared.isPaused = paused
        }
    }

    public var inAppMessagingDisplayInterval: String? {
        get {
            InAppAutomation.shared.inAppMessageManager.displayInterval.description
        }

        set {
            guard let intervalString = newValue,
                let interval = TimeInterval(intervalString) else {
                return
            }
            InAppAutomation.shared.inAppMessageManager.displayInterval = interval
        }
    }

}
