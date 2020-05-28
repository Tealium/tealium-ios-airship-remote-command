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

    let airshipTracker = MockAirshipTracker()
    var airshipRemoteCommand: AirshipRemoteCommand!
    var remoteCommand: TealiumRemoteCommand!
    
    override func setUp() {
        airshipRemoteCommand = AirshipRemoteCommand(airshipTracker: airshipTracker)
        remoteCommand = airshipRemoteCommand.remoteCommand()
    }

    override func tearDown() {

    }

    func testInitializeNotCalledWithoutConfig() {
        let expect = expectation(description: "test initialize")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                       payload: [
                                                        "command_name": "initialize",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                
                XCTAssertEqual(0, airshipTracker.initializeCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }

    func testInitializeNotCalledWithConfig() {
        let expect = expectation(description: "test initialize")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "initialize",
                                                        "airship_config": ["developmentAppKey": "abc123",
                                                                          "developmentAppSecret": "abc123"]
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                
                XCTAssertEqual(1, airshipTracker.initializeCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }

    func testParseCommandsNoCommand() {
        let expect = expectation(description: "test initialize")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "",
                                                        "airship_config": ["developmentAppKey": "abc123",
                                                                          "developmentAppSecret": "abc123"]
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                
                XCTAssertEqual(0, airshipTracker.initializeCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testTrackEventWithName() {
        let expect = expectation(description: "test track event")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "trackevent",
                                                        "event_name": "Test Event"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                
                XCTAssertEqual(1, airshipTracker.sendEventCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    
    func testTrackEventWithoutName() {
        let expect = expectation(description: "test track event")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "trackevent"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                
                XCTAssertEqual(0, airshipTracker.sendEventCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testTrackEventWithNameAndProperties() {
        let expect = expectation(description: "test track event")
        let testDictionary = ["my_test_property": 5.4]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "trackevent",
                                                        "event_name": "Test Event",
                                                        "event_value": "4.5",
                                                        "event_properties": testDictionary
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(4.5, airshipTracker.eventValue)
                XCTAssertEqual(testDictionary, airshipTracker.eventProperties! as! [String : Float64])
                XCTAssertEqual(1, airshipTracker.sendEventCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testTrackEventWithNameAndPropertiesIntValue() {
         let expect = expectation(description: "test track event")
         let testDictionary = ["my_test_property": 5.4]
         if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                       config: ["response_id": "1234"],
                                                        payload: [
                                                         "command_name": "trackevent",
                                                         "event_name": "Test Event",
                                                         "event_value": 4,
                                                         "event_properties": testDictionary
                                                         ])?.description {
             let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
             if let response = remoteCommandResponse {
                 remoteCommand.remoteCommandCompletion(response)
                 XCTAssertEqual(4.0, airshipTracker.eventValue)
                 XCTAssertEqual(testDictionary, airshipTracker.eventProperties! as! [String : Float64])
                 XCTAssertEqual(1, airshipTracker.sendEventCallCount)
             }
             expect.fulfill()
         }
         wait(for: [expect], timeout: 2.0)
     }
    
    func testTrackEventWithNameAndPropertiesFloatValue() {
        let expect = expectation(description: "test track event")
        let testDictionary = ["my_test_property": 5.4]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "trackevent",
                                                        "event_name": "Test Event",
                                                        "event_value": 4.5,
                                                        "event_properties": testDictionary
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(4.5, airshipTracker.eventValue)
                XCTAssertEqual(testDictionary, airshipTracker.eventProperties! as! [String : Float64])
                XCTAssertEqual(1, airshipTracker.sendEventCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testTrackEventNoEventName() {
        let expect = expectation(description: "test track event")
        let testDictionary = ["my_test_property": 5.4]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "trackevent",
                                                        "event_value": "4.5",
                                                        "event_properties": testDictionary
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.eventValue)
                XCTAssertNil(airshipTracker.eventProperties)
                XCTAssertEqual(0, airshipTracker.sendEventCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testTrackScreenWithName() {
        let expect = expectation(description: "test track screen")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "trackscreenview",
                                                        "screen_name": "Test Screen"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual("Test Screen", airshipTracker.screenName)
                XCTAssertEqual(1, airshipTracker.screenViewCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testTrackScreenWithoutName() {
        let expect = expectation(description: "test track screen")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "trackscreenview"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.screenName)
                XCTAssertEqual(0, airshipTracker.screenViewCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testAnalyticsEnabled() {
        let expect = expectation(description: "test analytics enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enableanalytics"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.analyticsEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testAnalyticsDisabled() {
        let expect = expectation(description: "test analytics disabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "disableanalytics"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.analyticsEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    
    func testSetNamedUserWithId() {
        let expect = expectation(description: "test named user")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setnameduser",
                                                        "named_user_identifier": "tealium1234"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.namedUserId!, "tealium1234")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetNamedUserWithoutId() {
        let expect = expectation(description: "test named user")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setnameduser"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.namedUserId)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetCustomIdentifiers() {
        let expect = expectation(description: "test custom identifiers")
        let customIdentifiers = ["email": "tealium@tealium.com",
        "hashed_email": "b0d560315488d6ac660f5acac0a62c3e74974760c33ab8fe6b0a6c4636679131"]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setcustomidentifiers",
                                                        "custom_identifiers": customIdentifiers
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.customIdentifiers!, customIdentifiers)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    
    func testSetCustomIdentifiersInvalidDictionary() {
        let expect = expectation(description: "test custom identifiers")
        let customIdentifiers: [String: Any] = ["email": "tealium@tealium.com",
        "hashed_email": "b0d560315488d6ac660f5acac0a62c3e74974760c33ab8fe6b0a6c4636679131",
        "number": 0.12]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setcustomidentifiers",
                                                        "custom_identifiers": customIdentifiers
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.customIdentifiers)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableAdvertisingIdentifiers() {
        let expect = expectation(description: "test custom identifiers")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enableadvertisingidentifiers",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.advertisingIdsEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableInAppMessaging() {
        let expect = expectation(description: "enable in-app messaging")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enableinappmessaging",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.inAppMessagingEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testDisableInAppMessaging() {
        let expect = expectation(description: "enable in-app messaging")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "disableinappmessaging",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.inAppMessagingEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testPauseInAppMessaging() {
        let expect = expectation(description: "pause in-app messaging")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "pauseinappmessaging",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.inAppMessagingPaused!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testUnpauseInAppMessaging() {
        let expect = expectation(description: "unpause in-app messaging")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "unpauseinappmessaging",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.inAppMessagingPaused!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetInAppMessagingDisplayIntervalNoInterval() {
        let expect = expectation(description: "set display interval")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setinappmessagingdisplayinterval",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.inAppMessagingDisplayInterval)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetInAppMessagingDisplayIntervalValidInterval() {
        let expect = expectation(description: "set display interval")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setinappmessagingdisplayinterval",
                                                        "in_app_messaging_display_interval": "10"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.inAppMessagingDisplayInterval, "10")
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableUserPushNotifications() {
        let expect = expectation(description: "enable user push notifications")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enableuserpushnotifications",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.userPushNotificationsEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableUserPushNotificationsWithOptions() {
        let expect = expectation(description: "enable user push notifications")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enableuserpushnotifications",
                                                        "push_notification_options": ["alert", "badge"],
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.pushNotificationOptions, ["alert", "badge"])
                XCTAssertTrue(airshipTracker.userPushNotificationsEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testDisableUserPushNotifications() {
        let expect = expectation(description: "enable user push notifications")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "disableuserpushnotifications",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.userPushNotificationsEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableBackgroundPushNotifications() {
        let expect = expectation(description: "enable user push notifications")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enablebackgroundpushnotifications",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.backgroundPushNotificationsEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testDisableBackgroundPushNotifications() {
        let expect = expectation(description: "disable background push notifications")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "disablebackgroundpushnotifications",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.backgroundPushNotificationsEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetPushNotificationOptions() {
        let expect = expectation(description: "set push notification options")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setpushnotificationoptions",
                                                        "push_notification_options": ["alert", "badge"],
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.pushNotificationOptions, ["alert", "badge"])
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetPushNotificationOptionsBadParams() {
        let expect = expectation(description: "set push notification options")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setpushnotificationoptions",
                                                        "push_notification_options": "",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.pushNotificationOptions)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetForegroundPresentationOptions() {
        let expect = expectation(description: "set foreground presentation options")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setforegroundpresentationoptions",
                                                        "foreground_presentation_options": ["alert", "badge"],
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.foregroundPresentationOptions, ["alert", "badge"])
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetForegroundPresentationOptionsBadParams() {
        let expect = expectation(description: "set foreground presentation options")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setforegroundpresentationoptions",
                                                        "foreground_presentation_options": ""
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.foregroundPresentationOptions)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetBadgeNumber() {
        let expect = expectation(description: "set badge number")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setbadgenumber",
                                                        "badge_number": 5
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.badgeNumber, 5)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetBadgeNumberBadParams() {
        let expect = expectation(description: "set badge number")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setbadgenumber",
                                                        "badge_number": 5.5
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.badgeNumber)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }

    func testResetBadgeNumber() {
        let expect = expectation(description: "reset badge number")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setbadgenumber,resetbadgenumber",
                                                        "badge_number": 5
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.badgeNumber, 0)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableAutoBadge() {
        let expect = expectation(description: "enable auto badge")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enableautobadge",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.autoBadgeEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testDisableAutoBadge() {
        let expect = expectation(description: "disable auto badge")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "disableautobadge",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.autoBadgeEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableQuietTime() {
        let expect = expectation(description: "enable quiet time")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enablequiettime",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.quietTimeEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testDisableQuietTime() {
        let expect = expectation(description: "disable quiet time")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "disablequiettime",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.quietTimeEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetQuietTimeStart() {
        let expect = expectation(description: "set quiet time start")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setquiettimestart",
                                                        "quiet_time_start_hour": 1,
                                                        "quiet_time_start_minute": 2,
                                                        "quiet_time_end_hour": 3,
                                                        "quiet_time_end_minute": 4,
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(airshipTracker.quietTime!["hour"], 1)
                XCTAssertEqual(airshipTracker.quietTime!["minute"], 2)
                XCTAssertEqual(airshipTracker.quietTime!["endhour"], 3)
                XCTAssertEqual(airshipTracker.quietTime!["endminute"], 4)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetQuietTimeStartMissingEnd() {
        let expect = expectation(description: "set quiet time start")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setquiettimestart",
                                                        "quiet_time_start_hour": 1,
                                                        "quiet_time_start_minute": 2,
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.quietTime)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetChannelTags() {
        let expect = expectation(description: "set channel tags")
        let channelTags = ["abc", "def"]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setchanneltags",
                                                        "channel_tags": channelTags,
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(channelTags, airshipTracker.channelTags)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetChannelTagsBadParams() {
        let expect = expectation(description: "set channel tags")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setchanneltags",
                                                        "channel_tags": "channelTags",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.channelTags)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetNamedUserTags() {
        let expect = expectation(description: "set channel tags")
        let userTags = ["abc", "def"]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setnamedusertags",
                                                        "named_user_tags": userTags,
                                                        "tag_group": "group",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(userTags, airshipTracker.userTags)
                XCTAssertEqual(airshipTracker.namedUserTagGroup, "group")
                
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetNamedUserTagsBadParams() {
        let expect = expectation(description: "set channel tags")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setnamedusertags",
                                                        "named_user_tags": "userTags",
                                                        "tag_group": "group",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.userTags)
                XCTAssertNil(airshipTracker.namedUserTagGroup)
                
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testAddTag() {
        let expect = expectation(description: "add tag")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "addtag",
                                                        "channel_tag": "abc",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.addTagCallCount)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testAddTagBadParams() {
        let expect = expectation(description: "add tag")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "addtag",
                                                        "channel_tag": 1,
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(0, airshipTracker.addTagCallCount)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testRemoveTag() {
        let expect = expectation(description: "remove tag")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "removetag",
                                                        "channel_tag": "abc",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.removeTagCallCount)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testRemoveTagBadParams() {
        let expect = expectation(description: "remove tag")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "removetag",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(0, airshipTracker.removeTagCallCount)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testAddTagGroupNamedUser() {
        let expect = expectation(description: "add tag group")
        let userTags = ["abc", "def"]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "addtaggroup",
                                                        "tag_group": "def",
                                                        "named_user_tags": userTags,
                                                        "tag_type": "named_user"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.addTagGroupCallCount)
                XCTAssertEqual(userTags, airshipTracker.namedUserTags)
                XCTAssertEqual("def", airshipTracker.tagGroup)
                XCTAssertEqual(.namedUser, airshipTracker.tagType)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testAddTagGroupChannel() {
        let expect = expectation(description: "add tag group channel")
        let channelTags = ["abc", "def"]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "addtaggroup",
                                                        "tag_group": "def",
                                                        "channel_tags": channelTags,
                                                        "tag_type": "channel"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.addTagGroupCallCount)
                XCTAssertEqual("def", airshipTracker.tagGroup)
                XCTAssertEqual(channelTags, airshipTracker.channelTags)
                XCTAssertEqual(.channel, airshipTracker.tagType)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testAddTagGroupChannelBadParams() {
        let expect = expectation(description: "add tag group channel")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "addtaggroup",
                                                        "tag_group": "def",
                                                        "channel_tags": "channelTags",
                                                        "tag_type": "channel"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(0, airshipTracker.addTagGroupCallCount)
                XCTAssertNil(airshipTracker.tagGroup)
                XCTAssertNil(airshipTracker.channelTags)
                XCTAssertNil(airshipTracker.tagType)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testRemoveTagGroupNamedUser() {
        let expect = expectation(description: "remove tag group")
        let userTags = ["abc", "def"]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "removetaggroup",
                                                        "tag_group": "def",
                                                        "named_user_tags": userTags,
                                                        "tag_type": "named_user"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.removeTagGroupCallCount)
                XCTAssertEqual(userTags, airshipTracker.namedUserTags)
                XCTAssertEqual("def", airshipTracker.tagGroup)
                XCTAssertEqual(.namedUser, airshipTracker.tagType)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testRemoveTagGroupChannel() {
        let expect = expectation(description: "remove tag group channel")
        let channelTags = ["abc", "def"]
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "removetaggroup",
                                                        "tag_group": "def",
                                                        "channel_tags": channelTags,
                                                        "tag_type": "channel"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.removeTagGroupCallCount)
                XCTAssertEqual("def", airshipTracker.tagGroup)
                XCTAssertEqual(channelTags, airshipTracker.channelTags)
                XCTAssertEqual(.channel, airshipTracker.tagType)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testRemoveTagGroupChannelBadParams() {
        let expect = expectation(description: "remove tag group channel")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "removetaggroup",
                                                        "tag_group": "def",
                                                        "channel_tags": "channelTags",
                                                        "tag_type": "channel"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(0, airshipTracker.removeTagGroupCallCount)
                XCTAssertNil(airshipTracker.tagGroup)
                XCTAssertNil(airshipTracker.channelTags)
                XCTAssertNil(airshipTracker.tagType)
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    
    func testSetAttributes() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setattributes",
                                                        "attributes": ["test":"attributes"],
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.setAttributesCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetAttributesBadAttributes() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setattributes",
                                                        "attributes": "hello"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(0, airshipTracker.setAttributesCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testDisplayMessageCenter() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "displaymessagecenter"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.displayMessageCenterCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetMessageCenterTitle() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setmessagecentertitle",
                                                        "message_center_title": "mytitle",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual("mytitle", airshipTracker.messageCenterTitle)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetMessageCenterTitleMissingTitle() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setmessageCentertitle",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertNil(airshipTracker.messageCenterTitle)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetMessageCenterStyle() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setmessagecenterstyle",
                                                        "message_center_style": ["my_style": "style"],
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(1, airshipTracker.setMessageCenterStyleCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSetMessageCenterStyleMissingDictionary() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "setmessagecenterstyle",
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(0, airshipTracker.setMessageCenterStyleCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableLocation() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enablelocation"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.locationEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    
    func testDisableLocation() {
        let expect = expectation(description: "test bg location disabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enablelocation, disablelocation"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.locationEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testEnableBackgroundLocation() {
        let expect = expectation(description: "test bg location enabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enablebackgroundlocation"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertTrue(airshipTracker.backgroundLocationEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testDisableBackgroundLocation() {
        let expect = expectation(description: "test bg location disabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "command_name": "enablebackgroundlocation, disablebackgroundlocation"
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertFalse(airshipTracker.backgroundLocationEnabled!)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testRemoteCommandNoCommandName() {
        let expect = expectation(description: "test bg location disabled")
        if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                      config: ["response_id": "1234"],
                                                       payload: [
                                                        "my_command": "hello",
                                                        "message_center_style": ["my_style": "style"],
                                                        ])?.description {
            let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
            if let response = remoteCommandResponse {
                remoteCommand.remoteCommandCompletion(response)
                XCTAssertEqual(0, airshipTracker.initializeCallCount)
                XCTAssertEqual(0, airshipTracker.sendEventCallCount)
                XCTAssertEqual(0, airshipTracker.screenViewCount)
                XCTAssertEqual(0, airshipTracker.resetCampaignDataCallCount)
                XCTAssertEqual(0, airshipTracker.loadFeedbackFormCallCount)
                XCTAssertEqual(0, airshipTracker.preloadFeedbackFormCallCount)
                XCTAssertEqual(0, airshipTracker.removeCachedFormsCallCount)
                XCTAssertEqual(0, airshipTracker.dismissAutomaticallyCallCount)
                XCTAssertEqual(0, airshipTracker.setCustomVariablesCallCount)
                XCTAssertEqual(0, airshipTracker.resetCallCount)
                XCTAssertEqual(0, airshipTracker.debugEnabledCallCount)
                XCTAssertEqual(0, airshipTracker.displayCampaignsCallCount)
                XCTAssertNil(airshipTracker.eventValue)
                XCTAssertNil(airshipTracker.eventProperties)
                XCTAssertNil(airshipTracker.screenName)
                XCTAssertNil(airshipTracker.namedUserId)
                XCTAssertNil(airshipTracker.advertisingIdsEnabled)
                XCTAssertNil(airshipTracker.quietTime)
                XCTAssertNil(airshipTracker.userTags)
                XCTAssertNil(airshipTracker.namedUserTagGroup)
                
                XCTAssertNil(airshipTracker.namedUserTags)
                XCTAssertNil(airshipTracker.tagGroup)
                XCTAssertNil(airshipTracker.tagType)
                
                XCTAssertEqual(0, airshipTracker.addTagCallCount)
                XCTAssertEqual(0, airshipTracker.addTagGroupCallCount)
                XCTAssertEqual(0, airshipTracker.removeTagGroupCallCount)
                XCTAssertEqual(0, airshipTracker.removeTagCallCount)
                XCTAssertEqual(0, airshipTracker.setAttributesCallCount)
                XCTAssertEqual(0, airshipTracker.setMessageCenterStyleCallCount)
                XCTAssertEqual(0, airshipTracker.displayMessageCenterCallCount)
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testRemoteCommandBadCommandName() {
          let expect = expectation(description: "test bg location disabled")
          if let response = HttpTestHelpers.httpRequest(commandId: "airship",
                                                        config: ["response_id": "1234"],
                                                         payload: [
                                                          "command_name": "hello",
                                                          "message_center_style": ["my_style": "style"],
                                                          ])?.description {
              let remoteCommandResponse = TealiumRemoteCommandResponse(urlString: response)
              if let response = remoteCommandResponse {
                  remoteCommand.remoteCommandCompletion(response)
                  XCTAssertEqual(0, airshipTracker.initializeCallCount)
                  XCTAssertEqual(0, airshipTracker.sendEventCallCount)
                  XCTAssertEqual(0, airshipTracker.screenViewCount)
                  XCTAssertEqual(0, airshipTracker.resetCampaignDataCallCount)
                  XCTAssertEqual(0, airshipTracker.loadFeedbackFormCallCount)
                  XCTAssertEqual(0, airshipTracker.preloadFeedbackFormCallCount)
                  XCTAssertEqual(0, airshipTracker.removeCachedFormsCallCount)
                  XCTAssertEqual(0, airshipTracker.dismissAutomaticallyCallCount)
                  XCTAssertEqual(0, airshipTracker.setCustomVariablesCallCount)
                  XCTAssertEqual(0, airshipTracker.resetCallCount)
                  XCTAssertEqual(0, airshipTracker.debugEnabledCallCount)
                  XCTAssertEqual(0, airshipTracker.displayCampaignsCallCount)
                  XCTAssertNil(airshipTracker.eventValue)
                  XCTAssertNil(airshipTracker.eventProperties)
                  XCTAssertNil(airshipTracker.screenName)
                  XCTAssertNil(airshipTracker.namedUserId)
                  XCTAssertNil(airshipTracker.advertisingIdsEnabled)
                  XCTAssertNil(airshipTracker.quietTime)
                  XCTAssertNil(airshipTracker.userTags)
                  XCTAssertNil(airshipTracker.namedUserTagGroup)
                  XCTAssertNil(airshipTracker.namedUserTags)
                  XCTAssertNil(airshipTracker.tagGroup)
                  XCTAssertNil(airshipTracker.tagType)
                  XCTAssertEqual(0, airshipTracker.addTagCallCount)
                  XCTAssertEqual(0, airshipTracker.addTagGroupCallCount)
                  XCTAssertEqual(0, airshipTracker.removeTagGroupCallCount)
                  XCTAssertEqual(0, airshipTracker.removeTagCallCount)
                  XCTAssertEqual(0, airshipTracker.setAttributesCallCount)
                  XCTAssertEqual(0, airshipTracker.setMessageCenterStyleCallCount)
                  XCTAssertEqual(0, airshipTracker.displayMessageCenterCallCount)
              }
              expect.fulfill()
          }
          wait(for: [expect], timeout: 2.0)
      }
    
}
