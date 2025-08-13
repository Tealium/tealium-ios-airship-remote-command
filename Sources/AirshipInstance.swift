//
//  AirshipInstance.swift
//
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import UIKit
#if COCOAPODS
import AirshipKit
import TealiumSwift
#else
import AirshipCore
import TealiumCore
#endif


public protocol AirshipCommand {

    func onReady(_ onReady: @escaping () -> Void)
    func initialize(_ config: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    // Segmentation
    var channelTags: [String]? { get set }
    func setNamedUserTags(_ group: String,
                          tags: [String])
    func addTag(_ tagName: String)
    func removeTag(_ tagName: String)
    func addTagGroup(_ group: String,
                     tags: [String],
                     for: UATagType)
    func removeTagGroup(_ group: String,
                        tags: [String],
                        for: UATagType)
    func setAttributes(_ attributes: [String: Any])
    func identifyUser(id: String)
    // Push Notifications
    func enablePushNotificationsWithOptions(_ options: [String])
    var userPushNotificationsEnabled: Bool? { get set }
    var backgroundPushNotificationsEnabled: Bool? { get set }
    var pushNotificationOptions: [String]? { get set }
    var foregroundPresentationOptions: [String]?  { get set }
    var badgeNumber: Int? { get set }
    func resetBadgeNumber()
    var autoBadgeEnabled: Bool? { get set }
    var quietTimeEnabled: Bool? { get set }
    func setQuietTimeStartHour(_ hour: Int, minute: Int, endHour: Int, endMinute: Int)
    // Analytics
    var customIdentifiers: [String: String]? { get set }
    func enableAdvertisingIDs()
    func trackScreenView(_ screenName: String)
    func trackEvent(_ eventName: String,
                                value: Float64?,
                                eventProperties: [String: Any]?)
    var analyticsEnabled: Bool? { get set }
    // Location
    var locationEnabled: Bool? { get set }
    var backgroundLocationEnabled: Bool? { get set }
    // Automation
    var inAppMessagingEnabled: Bool? { get set }
    var inAppMessagingPaused: Bool? { get set }
    var inAppMessagingDisplayInterval: String? { get set }
    // Message Center
    func displayMessageCenter()
    var messageCenterTitle: String? { get set }
    func setMessageCenterStyle(_ style: [String: Any])
        
}

public class AirshipInstance: AirshipCommand {

    private var _onReady = TealiumReplaySubject<Void>(cacheSize: 1)
    var currentNotificationOptions: [String]?
    var currentForegroundPresentationOptions: [String]?
    
    public init() { }
    
    public func onReady(_ onReady: @escaping () -> Void) {
        TealiumQueues.secureMainThreadExecution {  
            self._onReady.subscribeOnce(onReady)
        }
    }
    
    public func initialize(_ config: [String: Any], launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        DispatchQueue.main.async {
            Airship.takeOff(launchOptions: launchOptions ?? [:])
            self._onReady.publish()
        }
    }

}


