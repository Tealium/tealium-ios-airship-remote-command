//
//  AirshipMessaging.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 23/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

// Comment out if using Carthage
import Airship

// Uncomment if using Carthage
//import AirshipCore

extension UANotificationOptions: CustomStringConvertible {
    public var description: String {
        return ("\(self.contains(.badge) ? "badge, ": "")" +
        "\(self.contains(.sound) ? "sound, ": "")" +
        "\(self.contains(.alert) ? "alert, ": "")"  +
        "\(self.contains(.carPlay) ? "carPlay, ": "")" +
        "\(self.contains(.announcement) ? "announcement, ": "")"  +
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
            case "announcement":
                self.insert(.announcement)
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

extension AirshipTracker {
    // MARK: START PUSH
    
    public var userPushNotificationsEnabled: Bool? {
        get {
            UAirship.push()?.userPushNotificationsEnabled
        }
        
        set {
            guard let userPushEnabled = newValue else {
                return
            }
            UAirship.push()?.userPushNotificationsEnabled = userPushEnabled
            UAirship.push()?.updateRegistration()
        }
    }
    
    public var backgroundPushNotificationsEnabled: Bool? {
        get {
            UAirship.push()?.backgroundPushNotificationsEnabled
        }
        
        set {
            guard let backgroundPushNotificationsEnabled = newValue else {
                return
            }
            UAirship.push()?.backgroundPushNotificationsEnabled = backgroundPushNotificationsEnabled
            UAirship.push()?.updateRegistration()
        }
    }
    
    public func enablePushNotificationsWithOptions(_ options: [String]) {
        UAirship.push()?.notificationOptions = UANotificationOptions(options: options)
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
            UAirship.push()?.notificationOptions = UANotificationOptions(options: options)
            UAirship.push()?.updateRegistration()
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
            UAirship.push()?.defaultPresentationOptions = UNNotificationPresentationOptions(options: options)
            UAirship.push()?.updateRegistration()
        }
    }
    
    public var badgeNumber: Int? {
        get {
            UAirship.push()?.badgeNumber
        }
        
        set {
            guard let badgeNumber = newValue else {
                return
            }
            DispatchQueue.main.async {
                UAirship.push()?.badgeNumber = badgeNumber
            }
        }
        
    }
    
    public func resetBadgeNumber() {
        DispatchQueue.main.async {
            UAirship.push()?.resetBadge()
        }
    }
    
    public var autoBadgeEnabled: Bool? {
        get {
            UAirship.push()?.isAutobadgeEnabled
        }
        
        set {
            guard let isAutobadgeEnabled = newValue else {
                return
            }
            UAirship.push()?.isAutobadgeEnabled = isAutobadgeEnabled
        }
    }
    
    public var quietTimeEnabled: Bool? {
        get {
            UAirship.push()?.isQuietTimeEnabled
        }
        
        set {
            guard let isQuietTimeEnabled = newValue else {
                return
            }
            UAirship.push()?.isQuietTimeEnabled = isQuietTimeEnabled
            UAirship.push()?.updateRegistration()
        }
    }
    
    public func setQuietTimeStartHour(_ hour: Int, minute: Int, endHour: Int, endMinute: Int) {
        let hour = UInt(hour), minute = UInt(minute), endHour = UInt(endHour), endMinute = UInt(endMinute)
        UAirship.push()?.setQuietTimeStartHour(hour, startMinute: minute, endHour: endHour, endMinute: endMinute)
        UAirship.push()?.updateRegistration()
    }
}
