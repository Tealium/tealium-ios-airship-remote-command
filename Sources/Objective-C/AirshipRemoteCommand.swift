//
//  AirshipRemoteCommand.swift
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

import TealiumIOS

fileprivate extension Dictionary where Key: ExpressibleByStringLiteral {
    subscript(key: AirshipKey) -> Value? {
        get {
            return self[key.rawValue as! Key]
        }
        set {
            self[key.rawValue as! Key] = newValue
        }
    }
}

public class AirshipRemoteCommand: NSObject {
    
    var airshipTracker: AirshipTrackable
    
    @objc public override init() {
        self.airshipTracker = AirshipTracker()
    }
    
    public func remoteCommand() -> TEALRemoteCommandResponseBlock {
        return { response in
            guard let payload = response?.requestPayload as? [String: Any] else {
                return
            }
            guard let command = payload[AirshipConstants.commandName] as? String else {
                return
            }
            
            let commands = command.split(separator: AirshipConstants.separator)
            let airshipCommands = commands.map { command in
                return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            
            self.parseCommands(airshipCommands, payload: payload)
            
        }
    }
    
    public func parseCommands(_ commands: [String],
                              payload: [String: Any]) {
        commands.forEach { [weak self] command in
            guard let self = self else {
                return
            }
            let finalCommand = AirshipConstants.Commands(rawValue: command)
            switch finalCommand {
            case .initialize:
                guard let config = payload[AirshipConstants.Keys.airshipConfig] as? [String: Any] else {
                    return
                }
                self.airshipTracker.initialize(config)
                // MARK: START ANALYTICS
            case .trackEvent:
                guard let eventName = payload[AirshipConstants.Keys.eventName] as? String else {
                    return
                }
                let eventProperties = payload[AirshipConstants.Keys.eventProperties] as? [String: Any]
                var valueFloat: Float64? = nil
                if let eventValue = payload[AirshipConstants.Keys.eventValue] as? Int {
                    valueFloat = Float64(exactly: eventValue)
                } else if let eventValue = payload[AirshipConstants.Keys.eventValue] as? Float64 {
                    valueFloat = Float64(exactly: eventValue)
                } else if let eventValue = payload[AirshipConstants.Keys.eventValue] as? String {
                    valueFloat = Float64(eventValue)
                }
                self.airshipTracker.trackEvent(eventName, value: valueFloat, eventProperties: eventProperties)
            case .trackScreenView:
                guard let screenName = payload[AirshipConstants.Keys.screenName] as? String else {
                    return
                }
                self.airshipTracker.trackScreenView(screenName)
            case .enableAnalytics:
                self.airshipTracker.analyticsEnabled = true
            case .disableAnalytics:
                self.airshipTracker.analyticsEnabled = false
            case .setNamedUser:
                guard let userId = payload[AirshipConstants.Keys.namedUserIdentifier] as? String else {
                    return
                }
                self.airshipTracker.identifyUser(id: userId)
            case .setCustomIdentifiers:
                guard let customIdentifiers = payload[AirshipConstants.Keys.customIdentifiers] as? [String: String] else {
                    return
                }
                self.airshipTracker.customIdentifiers = customIdentifiers
            case .enableAdvertisingIdentifiers:
                self.airshipTracker.enableAdvertisingIDs()
            // MARK: START In-App Messaging
            case .enableInAppMessaging:
                self.airshipTracker.inAppMessagingEnabled = true
            case .disableInAppMessaging:
                self.airshipTracker.inAppMessagingEnabled = false
            case .pauseInAppMessaging:
                self.airshipTracker.inAppMessagingPaused = true
            case .unpauseInAppMessaging:
                self.airshipTracker.inAppMessagingPaused = false
            case .setInAppMessagingDisplayInterval:
                guard let interval = payload[AirshipConstants.Keys.inAppMessagingDisplayInterval] as? String else {
                    return
                }
                self.airshipTracker.inAppMessagingDisplayInterval = interval
            // MARK: START Push Messaging
            case .enableUserPushNotifications:
                if let notificationOptions = payload[AirshipConstants.Keys.pushNotificationOptions] as? [String] {
                    self.airshipTracker.enablePushNotificationsWithOptions(notificationOptions)
                } else {
                    self.airshipTracker.userPushNotificationsEnabled = true
                }
            case .disableUserPushNotifications:
                self.airshipTracker.userPushNotificationsEnabled = false
            case .enableBackgroundPushNotifications:
                self.airshipTracker.backgroundPushNotificationsEnabled = true
            case .disableBackgroundPushNotifications:
                self.airshipTracker.backgroundPushNotificationsEnabled = false
            case .setPushNotificationOptions:
                guard let notificationOptions = payload[AirshipConstants.Keys.pushNotificationOptions] as? [String] else {
                    return
                }
                self.airshipTracker.pushNotificationOptions = notificationOptions
            case .setForegroundPresentationOptions:
                guard let presentationOptions = payload[AirshipConstants.Keys.foregroundPresentationOptions] as? [String] else {
                    return
                }
                self.airshipTracker.foregroundPresentationOptions = presentationOptions
            case .setBadgeNumber:
                guard let badgeNumber = payload[AirshipConstants.Keys.badgeNumber] as? Int else {
                    return
                }
                self.airshipTracker.badgeNumber = badgeNumber
            case .resetBadgeNumber:
                self.airshipTracker.resetBadgeNumber()
            case .enableAutoBadge:
                self.airshipTracker.autoBadgeEnabled = true
            case .disableAutoBadge:
                self.airshipTracker.autoBadgeEnabled = false
            case .enableQuietTime:
                self.airshipTracker.quietTimeEnabled = true
            case .disableQuietTime:
                self.airshipTracker.quietTimeEnabled = false
            case .setQuietTimeStart:
                guard let startHour = payload[AirshipConstants.Keys.quietTimeStartHour] as? Int,
                    let startMinute = payload[AirshipConstants.Keys.quietTimeStartMinute] as? Int,
                    let endHour = payload[AirshipConstants.Keys.quietTimeEndHour] as? Int,
                    let endMinute = payload[AirshipConstants.Keys.quietTimeEndMinute] as? Int else {
                        return
                }
                
                self.airshipTracker.setQuietTimeStartHour(startHour, minute: startMinute, endHour: endHour, endMinute: endMinute)
            // MARK: START Segmentation
            case .setChannelTags:
                guard let tags = payload[AirshipConstants.Keys.channelTags] as? [String] else {
                    return
                }
                self.airshipTracker.channelTags = tags
            case .setNamedUserTags:
                guard let tags = payload[AirshipConstants.Keys.namedUserTags] as? [String],
                    let group = payload[AirshipConstants.Keys.tagGroup] as? String else {
                    return
                }
                self.airshipTracker.setNamedUserTags(group, tags: tags)
            case .addTag:
                guard let tag = payload[AirshipConstants.Keys.channelTag] as? String else {
                    return
                }
                self.airshipTracker.addTag(tag)
            case .removeTag:
                guard let tag = payload[AirshipConstants.Keys.channelTag] as? String else {
                    return
                }
                self.airshipTracker.removeTag(tag)
            case .addTagGroup:
                guard let tags = (payload[AirshipConstants.Keys.namedUserTags] ?? payload[AirshipConstants.Keys.channelTags]) as? [String],
                    let group = payload[AirshipConstants.Keys.tagGroup] as? String,
                    let tagType = payload[AirshipConstants.Keys.tagType] as? String,
                    let uaTagType = UATagType(rawValue: tagType) else {
                        return
                }
                self.airshipTracker.addTagGroup(group, tags: tags, for: uaTagType)
            case .removeTagGroup:
                guard let tags = (payload[AirshipConstants.Keys.namedUserTags] ?? payload[AirshipConstants.Keys.channelTags]) as? [String],
                    let group = payload[AirshipConstants.Keys.tagGroup] as? String,
                    let tagType = payload[AirshipConstants.Keys.tagType] as? String,
                    let uaTagType = UATagType(rawValue: tagType) else {
                    return
                }
                
                self.airshipTracker.removeTagGroup(group, tags: tags, for: uaTagType)
            case .setAttributes:
                guard let attributes = payload[AirshipConstants.Keys.attributes] as? [String: Any] else {
                    return
                }
                self.airshipTracker.setAttributes(attributes)
            // MARK: START MessageCenter
            case .displayMessageCenter:
                self.airshipTracker.displayMessageCenter()
            case .setMessageCenterTitle:
                guard let title = payload[AirshipConstants.Keys.messageCenterTitle] as? String else {
                    return
                }
                self.airshipTracker.messageCenterTitle = title
            case .setMessageCenterStyle:
                guard let style = payload[AirshipConstants.Keys.messageCenterStyle] as? [String: Any] else {
                    return
                }
                self.airshipTracker.setMessageCenterStyle(style)
            // MARK: START Location
            case .enableLocation:
                self.airshipTracker.locationEnabled = true
            case .disableLocation:
                self.airshipTracker.locationEnabled = false
            case .enableBackgroundLocation:
                self.airshipTracker.backgroundLocationEnabled = true
            case .disableBackgroundLocation:
                self.airshipTracker.backgroundLocationEnabled = false
            default:
                break
            }
        }
    }
    
}
