//
//  AirshipMessaging.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 23/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
import AirshipKit
#else
import AirshipCore
#endif

extension UANotificationOptions: CustomStringConvertible {
    public var description: String {
        return ("\(self.contains(.badge) ? "badge, ": "")" +
        "\(self.contains(.sound) ? "sound, ": "")" +
        "\(self.contains(.alert) ? "alert, ": "")"  +
        "\(self.contains(.carPlay) ? "carPlay, ": "")" +
        "\(self.contains(.criticalAlert) ? "criticalAlert, ": "")"  +
        "\(self.contains(.providesAppNotificationSettings) ? "providesAppNotificationSettings ,": "")" +
        "\(self.contains(.provisional) ? "provisional,": "")").trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
    }
    
    init(options: [String]) {
        self = UANotificationOptions()
        options.forEach {
            switch $0.lowercased() {
            case "badge":
                self.insert(.badge)
            case "sound":
                self.insert(.sound)
            case "alert":
                self.insert(.alert)
            case "carplay":
                self.insert(.carPlay)
            case "critical":
                self.insert(.criticalAlert)
            case "app_notification_settings":
                self.insert(.providesAppNotificationSettings)
            case "provisional":
                self.insert(.provisional)
            default:
                return
            }
        }
    }
}

extension UNNotificationPresentationOptions {
        init(options: [String]) {
            self = UNNotificationPresentationOptions()
            options.forEach {
                switch $0.lowercased() {
                case "badge":
                    self.insert(.badge)
                case "sound":
                    self.insert(.sound)
                case "alert":
                    self.insert(.alert)
                default:
                    return
                }
            }
        }
}

extension AirshipInstance {
    // MARK: START PUSH
    
    public var userPushNotificationsEnabled: Bool? {
        get {
            Airship.push.userPushNotificationsEnabled
        }
        
        set {
            guard let userPushEnabled = newValue else {
                return
            }
            Airship.push.userPushNotificationsEnabled = userPushEnabled
            Airship.push.updateRegistration()
        }
    }
    
    public var backgroundPushNotificationsEnabled: Bool? {
        get {
            Airship.push.backgroundPushNotificationsEnabled
        }
        
        set {
            guard let backgroundPushNotificationsEnabled = newValue else {
                return
            }
            Airship.push.backgroundPushNotificationsEnabled = backgroundPushNotificationsEnabled
            Airship.push.updateRegistration()
        }
    }
    
    public func enablePushNotificationsWithOptions(_ options: [String]) {
        Airship.push.notificationOptions = UANotificationOptions(options: options)
        userPushNotificationsEnabled = true
    }
    
    public var pushNotificationOptions: [String]? {
        get {
            return currentNotificationOptions
        }
        
        set {
            guard let options = newValue else {
                return
            }
            currentNotificationOptions = options
            Airship.push.notificationOptions = UANotificationOptions(options: options)
            Airship.push.updateRegistration()
        }
    }

    public var foregroundPresentationOptions: [String]? {
        get {
            return currentForegroundPresentationOptions
        }
        
        set {
            guard let options = newValue else {
                return
            }
            currentForegroundPresentationOptions = options
            Airship.push.defaultPresentationOptions = UNNotificationPresentationOptions(options: options)
            Airship.push.updateRegistration()
        }
    }
    
    public var badgeNumber: Int? {
        get {
            Airship.push.badgeNumber
        }
        
        set {
            guard let badgeNumber = newValue else {
                return
            }
            DispatchQueue.main.async {
                Airship.push.badgeNumber = badgeNumber
            }
        }
        
    }
    
    public func resetBadgeNumber() {
        DispatchQueue.main.async {
            Airship.push.resetBadge()
        }
    }
    
    public var autoBadgeEnabled: Bool? {
        get {
            Airship.push.autobadgeEnabled
        }
        
        set {
            guard let isAutobadgeEnabled = newValue else {
                return
            }
            Airship.push.autobadgeEnabled = isAutobadgeEnabled
        }
    }
    
    public var quietTimeEnabled: Bool? {
        get {
            Airship.push.quietTimeEnabled
        }
        
        set {
            guard let isQuietTimeEnabled = newValue else {
                return
            }
            Airship.push.quietTimeEnabled = isQuietTimeEnabled
            Airship.push.updateRegistration()
        }
    }
    
    public func setQuietTimeStartHour(_ hour: Int, minute: Int, endHour: Int, endMinute: Int) {
        Airship.push.setQuietTimeStartHour(hour, startMinute: minute, endHour: endHour, endMinute: endMinute)
        Airship.push.updateRegistration()
    }
}
