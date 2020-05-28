//
//  AirshipRemoteCommand.swift
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

import TealiumIOS

public enum AirshipCommands: String {
    
    case initialize
    case trackEvent = "trackevent"
    case trackScreenView = "trackscreenview"
    case enableAnalytics = "enableanalytics"
    case disableAnalytics = "disableanalytics"
    case setNamedUser = "setnameduser"
    case setCustomIdentifiers = "setcustomidentifiers"
    case enableAdvertisingIdentifiers = "enableadvertisingidentifiers"
    case enableInAppMessaging = "enableinappmessaging"
    case disableInAppMessaging = "disableinappmessaging"
    case pauseInAppMessaging = "pauseinappmessaging"
    case unpauseInAppMessaging = "unpauseinappmessaging"
    case setInAppMessagingDisplayInterval = "setinappmessagedisplayinterval"
    case enableUserPushNotifications = "enableuserpushnotifications"
    case disableUserPushNotifications = "disableuserpushnotifications"
    case enableBackgroundPushNotifications = "enablebackgroundpushnotifications"
    case disableBackgroundPushNotifications = "disablebackgroundpushnotifications"
    case setPushNotificationOptions = "setpushnotificationoptions"
    case setForegroundPresentationOptions = "setforegroundpresentationoptions"
    case setBadgeNumber = "setbadgenumber"
    case resetBadgeNumber = "resetbadgenumber"
    case enableAutoBadge = "enableautobadge"
    case disableAutoBadge = "disableautobadge"
    case enableQuietTime = "enablequiettime"
    case disableQuietTime = "disablequiettime"
    case setQuietTimeStart = "setquiettimestart"
    case setChannelTags = "setchanneltags"
    case setNamedUserTags = "setnamedusertags"
    case addTag = "addtag"
    case removeTag = "removetag"
    case addTagGroup = "addtaggroup"
    case removeTagGroup = "removetaggroup"
    case setAttributes = "setattributes"
    case displayMessageCenter = "displaymessagecenter"
    case setMessageCenterTitle = "setmessagecentertitle"
    case setMessageCenterStyle = "setmessagecenterstyle"
    case enableLocation = "enablelocation"
    case disableLocation = "disablelocation"
    case enableBackgroundLocation = "enablebackgroundlocation"
    case disableBackgroundLocation = "disablebackgroundlocation"
}

public enum AirshipKey: String {
    case airshipConfig = "airship_config"
    case eventName = "event_name"
    case eventProperties = "event_properties"
    case eventValue = "event_value"
    case screenName = "screen_name"
    case namedUserIdentifier = "named_user_identifier"
    case customIdentifiers = "custom_identifiers"
    case inAppMessagingDisplayInterval = "in_app_messaging_display_interval"
    case pushNotificationOptions = "push_notification_options"
    case quietTimeStartHour = "quiet_time_start_hour"
    case quietTimeStartMinute = "quiet_time_start_minute"
    case quietTimeEndHour = "quiet_time_end_hour"
    case quietTimeEndMinute = "quiet_time_end_minute"
    case badgeNumber = "badge_number"
    case foregroundPresentationOptions = "foreground_presentation_options"
    case namedUserTags = "named_user_tags"
    case channelTags = "channel_tags"
    case tagGroup = "tag_group"
    case channelTag = "channel_tag"
    case tagType = "tag_type"
    case attributes = "attributes"
    case messageCenterTitle = "message_center_title"
    case messageCenterStyle = "message_center_style"
    case command = "command_name"
}

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
            guard let command = payload[AirshipKey.command] as? String else {
                return
            }
            
            let commands = command.split(separator: ",")
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
                let finalCommand = AirshipCommands(rawValue: command)
                switch finalCommand {
                case .initialize:
                    guard let config = payload[AirshipKey.airshipConfig] as? [String: Any] else {
                        return
                    }
                    self.airshipTracker.initialize(config)
                    // MARK: START ANALYTICS
                case .trackEvent:
                    guard let eventName = payload[AirshipKey.eventName] as? String else {
                        return
                    }
                    let eventProperties = payload[AirshipKey.eventProperties] as? [String: Any]
                    var valueFloat: Float64? = nil
                    if let eventValue = payload[AirshipKey.eventValue] as? Int {
                        valueFloat = Float64(exactly: eventValue)
                    } else if let eventValue = payload[AirshipKey.eventValue] as? Float64 {
                        valueFloat = Float64(exactly: eventValue)
                    } else if let eventValue = payload[AirshipKey.eventValue] as? String {
                        valueFloat = Float64(eventValue)
                    }
                    self.airshipTracker.trackEvent(eventName, value: valueFloat, eventProperties: eventProperties)
                case .trackScreenView:
                    guard let screenName = payload[AirshipKey.screenName] as? String else {
                        return
                    }
                    self.airshipTracker.trackScreenView(screenName)
                case .enableAnalytics:
                    self.airshipTracker.analyticsEnabled = true
                case .disableAnalytics:
                    self.airshipTracker.analyticsEnabled = false
                case .setNamedUser:
                    guard let userId = payload[AirshipKey.namedUserIdentifier] as? String else {
                        return
                    }
                    self.airshipTracker.identifyUser(id: userId)
                case .setCustomIdentifiers:
                    guard let customIdentifiers = payload[AirshipKey.customIdentifiers] as? [String: String] else {
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
                    guard let interval = payload[AirshipKey.inAppMessagingDisplayInterval] as? String else {
                        return
                    }
                    self.airshipTracker.inAppMessagingDisplayInterval = interval
                // MARK: START Push Messaging
                case .enableUserPushNotifications:
                    if let notificationOptions = payload[AirshipKey.pushNotificationOptions] as? [String] {
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
                    guard let notificationOptions = payload[AirshipKey.pushNotificationOptions] as? [String] else {
                        return
                    }
                    self.airshipTracker.pushNotificationOptions = notificationOptions
                case .setForegroundPresentationOptions:
                    guard let presentationOptions = payload[AirshipKey.foregroundPresentationOptions] as? [String] else {
                        return
                    }
                    self.airshipTracker.foregroundPresentationOptions = presentationOptions
                case .setBadgeNumber:
                    guard let badgeNumber = payload[AirshipKey.badgeNumber] as? Int else {
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
                    guard let startHour = payload[AirshipKey.quietTimeStartHour] as? Int,
                        let startMinute = payload[AirshipKey.quietTimeStartMinute] as? Int,
                        let endHour = payload[AirshipKey.quietTimeEndHour] as? Int,
                        let endMinute = payload[AirshipKey.quietTimeEndMinute] as? Int else {
                            return
                    }
                    
                    self.airshipTracker.setQuietTimeStartHour(startHour, minute: startMinute, endHour: endHour, endMinute: endMinute)
                // MARK: START Segmentation
                case .setChannelTags:
                    guard let tags = payload[AirshipKey.channelTags] as? [String] else {
                        return
                    }
                    self.airshipTracker.channelTags = tags
                case .setNamedUserTags:
                    guard let tags = payload[AirshipKey.namedUserTags] as? [String],
                        let group = payload[AirshipKey.tagGroup] as? String else {
                        return
                    }
                    self.airshipTracker.setNamedUserTags(group, tags: tags)
                case .addTag:
                    guard let tag = payload[AirshipKey.channelTag] as? String else {
                        return
                    }
                    self.airshipTracker.addTag(tag)
                case .removeTag:
                    guard let tag = payload[AirshipKey.channelTag] as? String else {
                        return
                    }
                    self.airshipTracker.removeTag(tag)
                case .addTagGroup:
                    guard let tags = (payload[AirshipKey.namedUserTags] ?? payload[AirshipKey.channelTags]) as? [String],
                        let group = payload[AirshipKey.tagGroup] as? String,
                        let tagType = payload[AirshipKey.tagType] as? String,
                        let uaTagType = UATagType(rawValue: tagType) else {
                            return
                    }
                    self.airshipTracker.addTagGroup(group, tags: tags, for: uaTagType)
                case .removeTagGroup:
                    guard let tags = (payload[AirshipKey.namedUserTags] ?? payload[AirshipKey.channelTags]) as? [String],
                        let group = payload[AirshipKey.tagGroup] as? String,
                        let tagType = payload[AirshipKey.tagType] as? String,
                        let uaTagType = UATagType(rawValue: tagType) else {
                        return
                    }
                    
                    self.airshipTracker.removeTagGroup(group, tags: tags, for: uaTagType)
                case .setAttributes:
                    guard let attributes = payload[AirshipKey.attributes] as? [String: Any] else {
                        return
                    }
                    self.airshipTracker.setAttributes(attributes)
                // MARK: START MessageCenter
                case .displayMessageCenter:
                    self.airshipTracker.displayMessageCenter()
                case .setMessageCenterTitle:
                    guard let title = payload[AirshipKey.messageCenterTitle] as? String else {
                        return
                    }
                    self.airshipTracker.messageCenterTitle = title
                case .setMessageCenterStyle:
                    guard let style = payload[AirshipKey.messageCenterStyle] as? [String: Any] else {
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
