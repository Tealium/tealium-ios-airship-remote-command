//
//  AirshipConstants.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 29/05/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

enum AirshipConstants {
    
    static let commandName = "command_name"
    static let separator: Character = ","
    static let commandId = "airship"
    static let description = "Airship Remote Command"
    
    enum Commands: String {
        
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
        case setInAppMessagingDisplayInterval = "setinappmessagingdisplayinterval"
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

    enum Keys {
        static let eventName = "event_name"
        static let eventProperties = "event"
        static let eventValue = "event_value"
        static let screenName = "screen_name"
        static let namedUserIdentifier = "named_user_identifier"
        static let customIdentifiers = "custom"
        static let inAppMessagingDisplayInterval = "in_app_messaging_display_interval"
        static let pushNotificationOptions = "push_notification_options"
        static let quiet = "quiet"
        static let startHour = "start_hour"
        static let startMinute = "start_minute"
        static let endHour = "end_hour"
        static let endMinute = "end_minute"
        static let badgeNumber = "badge_number"
        static let foregroundPresentationOptions = "foreground_presentation_options"
        static let namedUserTags = "named_user_tags"
        static let channelTags = "channel_tags"
        static let tagGroup = "tag_group"
        static let channelTag = "channel_tag"
        static let tagType = "tag_type"
        static let attributes = "attributes"
        static let messageCenterTitle = "message_center_title"
        static let messageCenterStyle = "message_center_style"
    }
}


