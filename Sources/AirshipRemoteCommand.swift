//
//  AirshipCommand.swift
// 
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2019 Tealium. All rights reserved.
//
import Foundation

import os
#if COCOAPODS
import TealiumSwift
#else
import TealiumCore
import TealiumTagManagement
import TealiumRemoteCommands
#endif

public class AirshipRemoteCommand: RemoteCommand {
    
    var airshipInstance: AirshipCommand?
    var loggerLevel: TealiumLogLevel = .error
    
    public init(airshipInstance: AirshipCommand = AirshipInstance(),
                type: RemoteCommandType = .webview) {
        self.airshipInstance = airshipInstance
        weak var weakSelf: AirshipRemoteCommand?
        super.init(commandId: AirshipConstants.commandId,
                   description: AirshipConstants.description,
            type: type,
            completion: { response in
                guard let payload = response.payload else {
                    return
                }
                weakSelf?.processRemoteCommand(with: payload)
            })
        weakSelf = self
    }

    func processRemoteCommand(with payload: [String: Any]) {
        guard var airshipInstance = airshipInstance,
            let command = payload[AirshipConstants.commandName] as? String else {
                return
        }
        let commands = command.split(separator: AirshipConstants.separator)
        let airshipCommands = commands.map { command in
            return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        loggerLevel = logLevel(from: payload)
        log("Initialized")
        airshipCommands.forEach {
            let command = AirshipConstants.Commands(rawValue: $0.lowercased())
            switch command {
            case .initialize:
                airshipInstance.initialize(payload)
                // MARK: START ANALYTICS
            case .trackEvent:
                guard let eventName = payload[AirshipConstants.Keys.eventName] as? String else {
                    log("\(AirshipConstants.Keys.eventName) required for `trackEvent`")
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
                airshipInstance.trackEvent(eventName, value: valueFloat, eventProperties: eventProperties)
            case .trackScreenView:
                guard let screenName = payload[AirshipConstants.Keys.screenName] as? String else {
                    log("\(AirshipConstants.Keys.screenName) required for `trackScreenView`")
                    return
                }
                airshipInstance.trackScreenView(screenName)
            case .enableAnalytics:
                airshipInstance.analyticsEnabled = true
            case .disableAnalytics:
                airshipInstance.analyticsEnabled = false
            case .setNamedUser:
                guard let userId = payload[AirshipConstants.Keys.namedUserIdentifier] as? String else {
                    log("\(AirshipConstants.Keys.namedUserIdentifier) required for `setNamedUser`")
                    return
                }
                airshipInstance.identifyUser(id: userId)
            case .setCustomIdentifiers:
                guard let customIdentifiers = payload[AirshipConstants.Keys.customIdentifiers] as? [String: String] else {
                    log("\(AirshipConstants.Keys.customIdentifiers) required for `setCustomIdentifiers`")
                    return
                }
                airshipInstance.customIdentifiers = customIdentifiers
            case .enableAdvertisingIdentifiers:
                airshipInstance.enableAdvertisingIDs()
            // MARK: START In-App Messaging
            case .enableInAppMessaging:
                airshipInstance.inAppMessagingEnabled = true
            case .disableInAppMessaging:
                airshipInstance.inAppMessagingEnabled = false
            case .pauseInAppMessaging:
                airshipInstance.inAppMessagingPaused = true
            case .unpauseInAppMessaging:
                airshipInstance.inAppMessagingPaused = false
            case .setInAppMessagingDisplayInterval:
                guard let interval = payload[AirshipConstants.Keys.inAppMessagingDisplayInterval] as? String else {
                    log("\(AirshipConstants.Keys.inAppMessagingDisplayInterval) required for `setInAppMessagingDisplayInterval`")
                    return
                }
                airshipInstance.inAppMessagingDisplayInterval = interval
            // MARK: START Push Messaging
            case .enableUserPushNotifications:
                if let notificationOptions = payload[AirshipConstants.Keys.pushNotificationOptions] as? [String] {
                    airshipInstance.enablePushNotificationsWithOptions(notificationOptions)
                } else {
                    airshipInstance.userPushNotificationsEnabled = true
                }
            case .disableUserPushNotifications:
                airshipInstance.userPushNotificationsEnabled = false
            case .enableBackgroundPushNotifications:
                airshipInstance.backgroundPushNotificationsEnabled = true
            case .disableBackgroundPushNotifications:
                airshipInstance.backgroundPushNotificationsEnabled = false
            case .setPushNotificationOptions:
                guard let notificationOptions = payload[AirshipConstants.Keys.pushNotificationOptions] as? [String] else {
                    log("\(AirshipConstants.Keys.pushNotificationOptions) required for `setPushNotificationOptions`")
                    return
                }
                airshipInstance.pushNotificationOptions = notificationOptions
            case .setForegroundPresentationOptions:
                guard let presentationOptions = payload[AirshipConstants.Keys.foregroundPresentationOptions] as? [String] else {
                    log("\(AirshipConstants.Keys.foregroundPresentationOptions) required for `setForegroundPresentationOptions`")
                    return
                }
                airshipInstance.foregroundPresentationOptions = presentationOptions
            case .setBadgeNumber:
                guard let badgeNumber = payload[AirshipConstants.Keys.badgeNumber] as? Int else {
                    log("\(AirshipConstants.Keys.badgeNumber) required for `setBadgeNumber`")
                    return
                }
                airshipInstance.badgeNumber = badgeNumber
            case .resetBadgeNumber:
                airshipInstance.resetBadgeNumber()
            case .enableAutoBadge:
                airshipInstance.autoBadgeEnabled = true
            case .disableAutoBadge:
                airshipInstance.autoBadgeEnabled = false
            case .enableQuietTime:
                airshipInstance.quietTimeEnabled = true
            case .disableQuietTime:
                airshipInstance.quietTimeEnabled = false
            case .setQuietTimeStart:
                guard let quiet = payload[AirshipConstants.Keys.quiet] as? [String: Any],
                      let startHour = quiet[AirshipConstants.Keys.startHour] as? Int,
                      let startMinute = quiet[AirshipConstants.Keys.startMinute] as? Int,
                      let endHour = quiet[AirshipConstants.Keys.endHour] as? Int,
                      let endMinute = quiet[AirshipConstants.Keys.endMinute] as? Int else {
                        log("\(AirshipConstants.Keys.quiet) object required for `setQuietTimeStart`")
                        return
                }
                airshipInstance.setQuietTimeStartHour(startHour, minute: startMinute, endHour: endHour, endMinute: endMinute)
            // MARK: START Segmentation
            case .setChannelTags:
                guard let tags = payload[AirshipConstants.Keys.channelTags] as? [String] else {
                    log("\(AirshipConstants.Keys.channelTags) required for `setChannelTags`")
                    return
                }
                airshipInstance.channelTags = tags
            case .setNamedUserTags:
                guard let tags = payload[AirshipConstants.Keys.namedUserTags] as? [String],
                    let group = payload[AirshipConstants.Keys.tagGroup] as? String else {
                    log("\(AirshipConstants.Keys.namedUserTags) and \(AirshipConstants.Keys.tagGroup) required for `setNamedUserTags`")
                    return
                }
                airshipInstance.setNamedUserTags(group, tags: tags)
            case .addTag:
                guard let tag = payload[AirshipConstants.Keys.channelTag] as? String else {
                    log("\(AirshipConstants.Keys.channelTag) required for `addTag`")
                    return
                }
                airshipInstance.addTag(tag)
            case .removeTag:
                guard let tag = payload[AirshipConstants.Keys.channelTag] as? String else {
                    log("\(AirshipConstants.Keys.channelTag) required for `removeTag`")
                    return
                }
                airshipInstance.removeTag(tag)
            case .addTagGroup:
                guard let tags = (payload[AirshipConstants.Keys.namedUserTags] ?? payload[AirshipConstants.Keys.channelTags]) as? [String],
                    let group = payload[AirshipConstants.Keys.tagGroup] as? String,
                    let tagType = payload[AirshipConstants.Keys.tagType] as? String,
                    let uaTagType = UATagType(rawValue: tagType) else {
                    log("\(AirshipConstants.Keys.tagGroup) and \(AirshipConstants.Keys.tagType) required for `addTagGroup`")
                        return
                }
                airshipInstance.addTagGroup(group, tags: tags, for: uaTagType)
            case .removeTagGroup:
                guard let tags = (payload[AirshipConstants.Keys.namedUserTags] ?? payload[AirshipConstants.Keys.channelTags]) as? [String],
                    let group = payload[AirshipConstants.Keys.tagGroup] as? String,
                    let tagType = payload[AirshipConstants.Keys.tagType] as? String,
                    let uaTagType = UATagType(rawValue: tagType) else {
                    log("\(AirshipConstants.Keys.tagGroup) and \(AirshipConstants.Keys.tagType) required for `removeTagGroup`")
                    return
                }
                airshipInstance.removeTagGroup(group, tags: tags, for: uaTagType)
            case .setAttributes:
                guard let attributes = payload[AirshipConstants.Keys.attributes] as? [String: Any] else {
                    return
                }
                airshipInstance.setAttributes(attributes)
            // MARK: START MessageCenter
            case .displayMessageCenter:
                airshipInstance.displayMessageCenter()
            case .setMessageCenterTitle:
                guard let title = payload[AirshipConstants.Keys.messageCenterTitle] as? String else {
                    return
                }
                log("\(AirshipConstants.Keys.messageCenterTitle) required for `setMessageCenterTitle`")
                airshipInstance.messageCenterTitle = title
            case .setMessageCenterStyle:
                guard let style = payload[AirshipConstants.Keys.messageCenterStyle] as? [String: Any] else {
                    return
                }
                log("\(AirshipConstants.Keys.messageCenterStyle) object required for `setMessageCenterStyle`")
                airshipInstance.setMessageCenterStyle(style)
            // MARK: START Location
            case .enableLocation:
                airshipInstance.locationEnabled = true
            case .disableLocation:
                airshipInstance.locationEnabled = false
            case .enableBackgroundLocation:
                airshipInstance.backgroundLocationEnabled = true
            case .disableBackgroundLocation:
                airshipInstance.backgroundLocationEnabled = false
            default:
                break
            }
        }
    }
    
    private var environment: String {
        guard TealiumInstanceManager.shared.tealiumInstances.count == 1 else {
            return "productionLogLevel"
        }
        guard let tealium = TealiumInstanceManager.shared.tealiumInstances.first?.value,
              let environment = tealium.dataLayer.all[TealiumDataKey.environment] as? String else {
            return "productionLogLevel"
        }
       return environment == "prod" ? "productionLogLevel" : "developmentLogLevel"
    }
    
    private func logLevel(from payload: [String: Any]) -> TealiumLogLevel {
        guard let logLevel = payload[environment] as? String else {
            return .error
        }
        return TealiumLogLevel(from: logLevel)
    }
    
    private func log(_ message: String) {
        os_log("%{public}@",
               type: OSLogType(UInt8(loggerLevel.rawValue)),
               "\(AirshipConstants.description): \(message)")
    }
    
}
