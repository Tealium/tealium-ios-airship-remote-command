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
    static let commandDescription = "Airship Remote Command"
    
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

    enum Keys: String {
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
    }
}


