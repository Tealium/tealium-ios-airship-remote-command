//
//  AirshipTrackerTests.swift
//  RemoteCommandModulesTests
//
//  Created by Craig Rouse on 3/20/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumAirship
import TealiumRemoteCommands

class AirshipCommandRunnerTests: XCTestCase {

    let airshipInstance = MockAirshipInstance()
    var airshipRemoteCommand: AirshipRemoteCommand!
    
    override func setUp() {
        airshipRemoteCommand = AirshipRemoteCommand(airshipInstance: airshipInstance)
    }

    override func tearDown() {

    }

    func testInitializeNotCalledWithConfig() {
        let payload: [String : Any] = [
            "command_name": "initialize",
            "airship_config": ["developmentAppKey": "abc123",
                               "developmentAppSecret": "abc123"]
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.initializeCallCount)
    }

    func testParseCommandsNoCommand() {
        let payload: [String : Any] = [
            "command_name": "",
            "airship_config": ["developmentAppKey": "abc123",
                               "developmentAppSecret": "abc123"]
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, airshipInstance.initializeCallCount)
    }
    
    func testTrackEventWithName() {
        let payload: [String : Any] = [
            "command_name": "trackevent",
            "event_name": "Test Event"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.sendEventCallCount)
    }
    
    
    func testTrackEventWithoutName() {
        let payload: [String : Any] = [
            "command_name": "trackevent"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, airshipInstance.sendEventCallCount)
    }
    
    func testTrackEventWithNameAndProperties() {
        let testDictionary = ["my_test_property": 5.4]
        let payload: [String : Any] = [
            "command_name": "trackevent",
            "event_name": "Test Event",
            "event_value": "4.5",
            "event": testDictionary
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(4.5, airshipInstance.eventValue)
        XCTAssertEqual(testDictionary, airshipInstance.eventProperties! as! [String : Float64])
        XCTAssertEqual(1, airshipInstance.sendEventCallCount)
    }
    
    func testTrackEventWithNameAndPropertiesIntValue() {
        let testDictionary = ["my_test_property": 5.4]
        let payload: [String : Any] = [
            "command_name": "trackevent",
            "event_name": "Test Event",
            "event_value": 4,
            "event": testDictionary
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(4.0, airshipInstance.eventValue)
        XCTAssertEqual(testDictionary, airshipInstance.eventProperties! as! [String : Float64])
        XCTAssertEqual(1, airshipInstance.sendEventCallCount)
     }
    
    func testTrackEventWithNameAndPropertiesFloatValue() {
        let testDictionary = ["my_test_property": 5.4]
        let payload: [String : Any] = [
            "command_name": "trackevent",
            "event_name": "Test Event",
            "event_value": 4.5,
            "event": testDictionary
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(4.5, airshipInstance.eventValue)
        XCTAssertEqual(testDictionary, airshipInstance.eventProperties! as! [String : Float64])
        XCTAssertEqual(1, airshipInstance.sendEventCallCount)
    }
    
    func testTrackEventNoEventName() {
        let testDictionary = ["my_test_property": 5.4]
        let payload: [String : Any] = [
            "command_name": "trackevent",
            "event_value": "4.5",
            "event": testDictionary
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.eventValue)
        XCTAssertNil(airshipInstance.eventProperties)
        XCTAssertEqual(0, airshipInstance.sendEventCallCount)
    }
    
    func testTrackScreenWithName() {
        let payload: [String : Any] = [
            "command_name": "trackscreenview",
            "screen_name": "Test Screen"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual("Test Screen", airshipInstance.screenName)
        XCTAssertEqual(1, airshipInstance.screenViewCount)
    }
    
    func testTrackScreenWithoutName() {
        let payload = [
            "command_name": "trackscreenview"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.screenName)
        XCTAssertEqual(0, airshipInstance.screenViewCount)
    }
    
    func testAnalyticsEnabled() {
        let payload = [
            "command_name": "enableanalytics"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.analyticsEnabled!)
    }
    
    func testAnalyticsDisabled() {
        let payload = [
            "command_name": "disableanalytics"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.analyticsEnabled!)
    }
    
    
    func testSetNamedUserWithId() {
        let payload = [
            "command_name": "setnameduser",
            "named_user_identifier": "tealium1234"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.namedUserId!, "tealium1234")
    }
    
    func testSetNamedUserWithoutId() {
        let payload = [
            "command_name": "setnameduser"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.namedUserId)
    }
    
    func testSetCustomIdentifiers() {
        let customIdentifiers = ["email": "tealium@tealium.com",
        "hashed_email": "b0d560315488d6ac660f5acac0a62c3e74974760c33ab8fe6b0a6c4636679131"]
        let payload: [String : Any] = [
                                                        "command_name": "setcustomidentifiers",
                                                        "custom": customIdentifiers
                                                        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.customIdentifiers!, customIdentifiers)
    }
    
    
    func testSetCustomIdentifiersInvalidDictionary() {
        let customIdentifiers: [String: Any] = ["email": "tealium@tealium.com",
                                                "hashed_email": "b0d560315488d6ac660f5acac0a62c3e74974760c33ab8fe6b0a6c4636679131",
                                                "number": 0.12]
        let payload: [String : Any] = [
            "command_name": "setcustomidentifiers",
            "custom": customIdentifiers
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.customIdentifiers)
    }
    
    func testEnableAdvertisingIdentifiers() {
        let payload: [String : Any] = [
            "command_name": "enableadvertisingidentifiers",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.advertisingIdsEnabled!)
    }
    
    func testEnableInAppMessaging() {
        let payload: [String : Any] = [
            "command_name": "enableinappmessaging",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.inAppMessagingEnabled!)
    }
    
    func testDisableInAppMessaging() {
        let payload = [
            "command_name": "disableinappmessaging",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.inAppMessagingEnabled!)
    }
    
    func testPauseInAppMessaging() {
        let payload: [String : Any] = [
            "command_name": "pauseinappmessaging",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.inAppMessagingPaused!)
    }
    
    func testUnpauseInAppMessaging() {
        let payload: [String : Any] = [
            "command_name": "unpauseinappmessaging",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.inAppMessagingPaused!)
    }
    
    func testSetInAppMessagingDisplayIntervalNoInterval() {
        let payload: [String : Any] = [
            "command_name": "setinappmessagingdisplayinterval",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.inAppMessagingDisplayInterval)
    }
    
    func testSetInAppMessagingDisplayIntervalValidInterval() {
        let payload: [String : Any] = [
            "command_name": "setinappmessagingdisplayinterval",
            "in_app_messaging_display_interval": "10"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.inAppMessagingDisplayInterval, "10")
    }
    
    func testEnableUserPushNotifications() {
        let payload: [String : Any] = [
            "command_name": "enableuserpushnotifications",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.userPushNotificationsEnabled!)
    }
    
    func testEnableUserPushNotificationsWithOptions() {
        let payload: [String : Any] = [
            "command_name": "enableuserpushnotifications",
            "push_notification_options": ["alert", "badge"],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.pushNotificationOptions, ["alert", "badge"])
        XCTAssertTrue(airshipInstance.userPushNotificationsEnabled!)
    }
    
    func testDisableUserPushNotifications() {
        let payload: [String : Any] = [
            "command_name": "disableuserpushnotifications",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.userPushNotificationsEnabled!)
    }
    
    func testEnableBackgroundPushNotifications() {
        let payload: [String : Any] = [
            "command_name": "enablebackgroundpushnotifications",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.backgroundPushNotificationsEnabled!)
    }
    
    func testDisableBackgroundPushNotifications() {
        let payload: [String : Any] = [
            "command_name": "disablebackgroundpushnotifications",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.backgroundPushNotificationsEnabled!)
    }
    
    func testSetPushNotificationOptions() {
        let payload: [String : Any] = [
            "command_name": "setpushnotificationoptions",
            "push_notification_options": ["alert", "badge"],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.pushNotificationOptions, ["alert", "badge"])
    }
    
    func testSetPushNotificationOptionsBadParams() {
        let payload: [String : Any] = [
            "command_name": "setpushnotificationoptions",
            "push_notification_options": "",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.pushNotificationOptions)
    }
    
    func testSetForegroundPresentationOptions() {
        let payload: [String : Any] = [
            "command_name": "setforegroundpresentationoptions",
            "foreground_presentation_options": ["alert", "badge"],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.foregroundPresentationOptions, ["alert", "badge"])
    }
    
    func testSetForegroundPresentationOptionsBadParams() {
        let payload: [String : Any] = [
            "command_name": "setforegroundpresentationoptions",
            "foreground_presentation_options": ""
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.foregroundPresentationOptions)
    }
    
    func testSetBadgeNumber() {
        let payload: [String : Any] = [
            "command_name": "setbadgenumber",
            "badge_number": 5
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.badgeNumber, 5)
    }
    
    func testSetBadgeNumberBadParams() {
        let payload: [String : Any] = [
            "command_name": "setbadgenumber",
            "badge_number": 5.5
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.badgeNumber)
    }

    func testResetBadgeNumber() {
        let payload: [String : Any] = [
            "command_name": "setbadgenumber,resetbadgenumber",
            "badge_number": 5
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.badgeNumber, 0)
    }
    
    func testEnableAutoBadge() {
        let payload: [String : Any] = [
            "command_name": "enableautobadge",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.autoBadgeEnabled!)
    }
    
    func testDisableAutoBadge() {
        let payload: [String : Any] = [
            "command_name": "disableautobadge",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.autoBadgeEnabled!)
    }
    
    func testEnableQuietTime() {
        let payload: [String : Any] = [
            "command_name": "enablequiettime",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.quietTimeEnabled!)
    }
    
    func testDisableQuietTime() {
        let payload: [String : Any] = [
            "command_name": "disablequiettime",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.quietTimeEnabled!)
    }
    
    func testSetQuietTimeStart() {
        let payload: [String : Any] = [
            "command_name": "setquiettimestart",
            "quiet": ["start_hour": 1,
                      "start_minute": 2,
                      "end_hour": 3,
                      "end_minute": 4],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(airshipInstance.quietTime!["hour"], 1)
        XCTAssertEqual(airshipInstance.quietTime!["minute"], 2)
        XCTAssertEqual(airshipInstance.quietTime!["endhour"], 3)
        XCTAssertEqual(airshipInstance.quietTime!["endminute"], 4)
    }
    
    func testSetQuietTimeStartMissingEnd() {
        let payload: [String : Any] = [
            "command_name": "setquiettimestart",
            "quiet": ["start_hour": 1,
                      "start_minute": 2],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.quietTime)
    }
    
    func testSetChannelTags() {
        let channelTags = ["abc", "def"]
        let payload: [String : Any] = [
            "command_name": "setchanneltags",
            "channel_tags": channelTags,
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(channelTags, airshipInstance.channelTags)
    }
    
    func testSetChannelTagsBadParams() {
        let payload: [String : Any] = [
            "command_name": "setchanneltags",
            "channel_tags": "channelTags",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.channelTags)
    }
    
    func testSetNamedUserTags() {
        let userTags = ["abc", "def"]
        let payload: [String : Any] = [
            "command_name": "setnamedusertags",
            "named_user_tags": userTags,
            "tag_group": "group",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(userTags, airshipInstance.userTags)
        XCTAssertEqual(airshipInstance.namedUserTagGroup, "group")
    }
    
    func testSetNamedUserTagsBadParams() {
        let payload: [String : Any] = [
            "command_name": "setnamedusertags",
            "named_user_tags": "userTags",
            "tag_group": "group",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.userTags)
        XCTAssertNil(airshipInstance.namedUserTagGroup)
    }
    
    func testAddTag() {
        let payload: [String : Any] = [
            "command_name": "addtag",
            "channel_tag": "abc",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.addTagCallCount)
    }
    
    func testAddTagBadParams() {
        let payload: [String : Any] = [
            "command_name": "addtag",
            "channel_tag": 1,
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, airshipInstance.addTagCallCount)
    }
    
    func testRemoveTag() {
        let payload: [String : Any] = [
            "command_name": "removetag",
            "channel_tag": "abc",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.removeTagCallCount)
    }
    
    func testRemoveTagBadParams() {
        let payload:  [String : Any] = [
            "command_name": "removetag",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, airshipInstance.removeTagCallCount)
    }
    
    func testAddTagGroupNamedUser() {
        let userTags = ["abc", "def"]
        let payload: [String : Any] = [
            "command_name": "addtaggroup",
            "tag_group": "def",
            "named_user_tags": userTags,
            "tag_type": "named_user"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.addTagGroupCallCount)
        XCTAssertEqual(userTags, airshipInstance.namedUserTags)
        XCTAssertEqual("def", airshipInstance.tagGroup)
        XCTAssertEqual(.namedUser, airshipInstance.tagType)
    }
    
    func testAddTagGroupChannel() {
        let channelTags = ["abc", "def"]
        let payload: [String : Any] = [
            "command_name": "addtaggroup",
            "tag_group": "def",
            "channel_tags": channelTags,
            "tag_type": "channel"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.addTagGroupCallCount)
        XCTAssertEqual("def", airshipInstance.tagGroup)
        XCTAssertEqual(channelTags, airshipInstance.channelTags)
        XCTAssertEqual(.channel, airshipInstance.tagType)
    }
    
    func testAddTagGroupChannelBadParams() {
        let payload: [String : Any] = [
            "command_name": "addtaggroup",
            "tag_group": "def",
            "channel_tags": "channelTags",
            "tag_type": "channel"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, airshipInstance.addTagGroupCallCount)
        XCTAssertNil(airshipInstance.tagGroup)
        XCTAssertNil(airshipInstance.channelTags)
        XCTAssertNil(airshipInstance.tagType)
    }
    
    func testRemoveTagGroupNamedUser() {
        let userTags = ["abc", "def"]
        let payload: [String : Any] = [
            "command_name": "removetaggroup",
            "tag_group": "def",
            "named_user_tags": userTags,
            "tag_type": "named_user"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.removeTagGroupCallCount)
        XCTAssertEqual(userTags, airshipInstance.namedUserTags)
        XCTAssertEqual("def", airshipInstance.tagGroup)
        XCTAssertEqual(.namedUser, airshipInstance.tagType)
    }
    
    func testRemoveTagGroupChannel() {
        let channelTags = ["abc", "def"]
        let payload: [String : Any] = [
            "command_name": "removetaggroup",
            "tag_group": "def",
            "channel_tags": channelTags,
            "tag_type": "channel"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.removeTagGroupCallCount)
        XCTAssertEqual("def", airshipInstance.tagGroup)
        XCTAssertEqual(channelTags, airshipInstance.channelTags)
        XCTAssertEqual(.channel, airshipInstance.tagType)
    }
    
    func testRemoveTagGroupChannelBadParams() {
        let payload: [String : Any] = [
            "command_name": "removetaggroup",
            "tag_group": "def",
            "channel_tags": "channelTags",
            "tag_type": "channel"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, airshipInstance.removeTagGroupCallCount)
        XCTAssertNil(airshipInstance.tagGroup)
        XCTAssertNil(airshipInstance.channelTags)
        XCTAssertNil(airshipInstance.tagType)
    }
    
    
    func testSetAttributes() {
        let payload: [String : Any] = [
            "command_name": "setattributes",
            "attributes": ["test":"attributes"],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.setAttributesCallCount)
    }
    
    func testSetAttributesBadAttributes() {
        let payload: [String : Any] = [
            "command_name": "setattributes",
            "attributes": "hello"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, airshipInstance.setAttributesCallCount)
    }
    
    func testDisplayMessageCenter() {
        let payload: [String : Any] = [
            "command_name": "displaymessagecenter"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.displayMessageCenterCallCount)
    }
    
    func testSetMessageCenterTitle() {
        let payload:  [String : Any] = [
            "command_name": "setmessagecentertitle",
            "message_center_title": "mytitle",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual("mytitle", airshipInstance.messageCenterTitle)
    }
    
    func testSetMessageCenterTitleMissingTitle() {
        let payload: [String : Any] = [
            "command_name": "setmessageCentertitle",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertNil(airshipInstance.messageCenterTitle)
    }
    
    func testSetMessageCenterStyle() {
        let payload: [String : Any] = [
            "command_name": "setmessagecenterstyle",
            "message_center_style": ["my_style": "style"],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, airshipInstance.setMessageCenterStyleCallCount)
    }
    
    func testSetMessageCenterStyleMissingDictionary() {
        let payload: [String : Any] = [
            "command_name": "setmessagecenterstyle",
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, airshipInstance.setMessageCenterStyleCallCount)
    }
    
    func testEnableLocation() {
        let payload: [String : Any] = [
            "command_name": "enablelocation"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.locationEnabled!)
    }
    
    
    func testDisableLocation() {
        let payload: [String : Any] = [
            "command_name": "enablelocation, disablelocation"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.locationEnabled!)
    }
    
    func testEnableBackgroundLocation() {
        let payload: [String : Any] = [
            "command_name": "enablebackgroundlocation"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(airshipInstance.backgroundLocationEnabled!)
    }
    
    func testDisableBackgroundLocation() {
        let payload: [String : Any] = [
            "command_name": "enablebackgroundlocation, disablebackgroundlocation"
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(airshipInstance.backgroundLocationEnabled!)
    }
    
    func testRemoteCommandNoCommandName() {
        let payload: [String : Any] = [
            "my_command": "hello",
            "message_center_style": ["my_style": "style"],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        
        XCTAssertEqual(0, airshipInstance.initializeCallCount)
        XCTAssertEqual(0, airshipInstance.sendEventCallCount)
        XCTAssertEqual(0, airshipInstance.screenViewCount)
        XCTAssertEqual(0, airshipInstance.resetCampaignDataCallCount)
        XCTAssertEqual(0, airshipInstance.loadFeedbackFormCallCount)
        XCTAssertEqual(0, airshipInstance.preloadFeedbackFormCallCount)
        XCTAssertEqual(0, airshipInstance.removeCachedFormsCallCount)
        XCTAssertEqual(0, airshipInstance.dismissAutomaticallyCallCount)
        XCTAssertEqual(0, airshipInstance.setCustomVariablesCallCount)
        XCTAssertEqual(0, airshipInstance.resetCallCount)
        XCTAssertEqual(0, airshipInstance.debugEnabledCallCount)
        XCTAssertEqual(0, airshipInstance.displayCampaignsCallCount)
        XCTAssertNil(airshipInstance.eventValue)
        XCTAssertNil(airshipInstance.eventProperties)
        XCTAssertNil(airshipInstance.screenName)
        XCTAssertNil(airshipInstance.namedUserId)
        XCTAssertNil(airshipInstance.advertisingIdsEnabled)
        XCTAssertNil(airshipInstance.quietTime)
        XCTAssertNil(airshipInstance.userTags)
        XCTAssertNil(airshipInstance.namedUserTagGroup)
        
        XCTAssertNil(airshipInstance.namedUserTags)
        XCTAssertNil(airshipInstance.tagGroup)
        XCTAssertNil(airshipInstance.tagType)
        
        XCTAssertEqual(0, airshipInstance.addTagCallCount)
        XCTAssertEqual(0, airshipInstance.addTagGroupCallCount)
        XCTAssertEqual(0, airshipInstance.removeTagGroupCallCount)
        XCTAssertEqual(0, airshipInstance.removeTagCallCount)
        XCTAssertEqual(0, airshipInstance.setAttributesCallCount)
        XCTAssertEqual(0, airshipInstance.setMessageCenterStyleCallCount)
        XCTAssertEqual(0, airshipInstance.displayMessageCenterCallCount)
    }
    
    func testRemoteCommandBadCommandName() {
        let payload: [String : Any] = [
            "command_name": "hello",
            "message_center_style": ["my_style": "style"],
        ]
        airshipRemoteCommand.processRemoteCommand(with: payload)
        
        XCTAssertEqual(0, airshipInstance.initializeCallCount)
        XCTAssertEqual(0, airshipInstance.sendEventCallCount)
        XCTAssertEqual(0, airshipInstance.screenViewCount)
        XCTAssertEqual(0, airshipInstance.resetCampaignDataCallCount)
        XCTAssertEqual(0, airshipInstance.loadFeedbackFormCallCount)
        XCTAssertEqual(0, airshipInstance.preloadFeedbackFormCallCount)
        XCTAssertEqual(0, airshipInstance.removeCachedFormsCallCount)
        XCTAssertEqual(0, airshipInstance.dismissAutomaticallyCallCount)
        XCTAssertEqual(0, airshipInstance.setCustomVariablesCallCount)
        XCTAssertEqual(0, airshipInstance.resetCallCount)
        XCTAssertEqual(0, airshipInstance.debugEnabledCallCount)
        XCTAssertEqual(0, airshipInstance.displayCampaignsCallCount)
        XCTAssertNil(airshipInstance.eventValue)
        XCTAssertNil(airshipInstance.eventProperties)
        XCTAssertNil(airshipInstance.screenName)
        XCTAssertNil(airshipInstance.namedUserId)
        XCTAssertNil(airshipInstance.advertisingIdsEnabled)
        XCTAssertNil(airshipInstance.quietTime)
        XCTAssertNil(airshipInstance.userTags)
        XCTAssertNil(airshipInstance.namedUserTagGroup)
        XCTAssertNil(airshipInstance.namedUserTags)
        XCTAssertNil(airshipInstance.tagGroup)
        XCTAssertNil(airshipInstance.tagType)
        XCTAssertEqual(0, airshipInstance.addTagCallCount)
        XCTAssertEqual(0, airshipInstance.addTagGroupCallCount)
        XCTAssertEqual(0, airshipInstance.removeTagGroupCallCount)
        XCTAssertEqual(0, airshipInstance.removeTagCallCount)
        XCTAssertEqual(0, airshipInstance.setAttributesCallCount)
        XCTAssertEqual(0, airshipInstance.setMessageCenterStyleCallCount)
        XCTAssertEqual(0, airshipInstance.displayMessageCenterCallCount)
      }
    
}
