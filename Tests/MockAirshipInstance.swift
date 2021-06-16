//
//  MockAirshipInstance.swift
//  TealiumAirshipTests
//
//  Created by Craig Rouse on 30/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
@testable import TealiumAirship

class MockAirshipInstance: AirshipCommand {
    
    var initializeCallCount = 0
    var sendEventCallCount = 0
    var screenViewCount = 0
    var resetCampaignDataCallCount = 0
    var loadFeedbackFormCallCount = 0
    var preloadFeedbackFormCallCount = 0
    var removeCachedFormsCallCount = 0
    var dismissAutomaticallyCallCount = 0
    var setCustomVariablesCallCount = 0
    var resetCallCount = 0
    var debugEnabledCallCount = 0
    var displayCampaignsCallCount = 0
    var eventValue: Float64?
    var eventProperties: [String: Any]?
    var screenName: String?
    var namedUserId: String?
    var advertisingIdsEnabled: Bool?
    var quietTime: [String: Int]?
    var userTags: [String]?
    var namedUserTagGroup: String?
    var addTagCallCount = 0
    var addTagGroupCallCount = 0
    var removeTagGroupCallCount = 0
    var removeTagCallCount = 0
    var namedUserTags: [String]?
    var tagGroup: String?
    var tagType: UATagType?
    var setAttributesCallCount = 0
    var setMessageCenterStyleCallCount = 0
    var displayMessageCenterCallCount = 0
    
    
    func initialize(_ config: [String : Any]) {
        initializeCallCount += 1
    }
    
    var channelTags: [String]?
    
    func setNamedUserTags(_ group: String, tags: [String]) {
        namedUserTagGroup = group
        userTags = tags
    }
    
    func addTag(_ tagName: String) {
        addTagCallCount += 1
    }
    
    func removeTag(_ tagName: String) {
        removeTagCallCount += 1
    }
    
    func addTagGroup(_ group: String, tags: [String], for type: UATagType) {
        addTagGroupCallCount += 1
        tagType = type
        tagGroup = group
        switch type {
        case .channel:
            channelTags = tags
        default:
            namedUserTags = tags
        }
    }
    
    func removeTagGroup(_ group: String, tags: [String], for type: UATagType) {
        removeTagGroupCallCount += 1
        tagType = type
        tagGroup = group
        switch type {
        case .channel:
            channelTags = tags
        default:
            namedUserTags = tags
        }
    }
    
    func setAttributes(_ attributes: [String : Any]) {
        setAttributesCallCount += 1
    }
    
    func identifyUser(id: String) {
        namedUserId = id
    }
    
    func enablePushNotificationsWithOptions(_ options: [String]) {
        self.pushNotificationOptions = options
        self.userPushNotificationsEnabled = true
    }
    
    var userPushNotificationsEnabled: Bool?
    
    var backgroundPushNotificationsEnabled: Bool?
    
    var pushNotificationOptions: [String]?
    
    var foregroundPresentationOptions: [String]?
    
    var badgeNumber: Int?
    
    func resetBadgeNumber() {
        self.badgeNumber = 0
    }
    
    var autoBadgeEnabled: Bool?
    
    var quietTimeEnabled: Bool?
    
    func setQuietTimeStartHour(_ hour: Int, minute: Int, endHour: Int, endMinute: Int) {
            quietTime = [String: Int]()
            quietTime!["hour"] = hour
            quietTime!["minute"] = minute
            quietTime!["endhour"] = endHour
            quietTime!["endminute"] = endMinute
    }
    
    var customIdentifiers: [String : String]?
    
    func enableAdvertisingIDs() {
        self.advertisingIdsEnabled = true
    }
    
    func trackScreenView(_ screenName: String) {
        self.screenName = screenName
        screenViewCount += 1
    }
    
    func trackEvent(_ eventName: String, value: Float64?, eventProperties: [String : Any]?) {
        sendEventCallCount += 1
        self.eventValue = value
        self.eventProperties = eventProperties
    }
    
    var analyticsEnabled: Bool?
    
    var locationEnabled: Bool?
    
    var backgroundLocationEnabled: Bool?
    
    var dataCollectionEnabled: Bool?
    
    var inAppMessagingEnabled: Bool?
    
    var inAppMessagingPaused: Bool?
    
    var inAppMessagingDisplayInterval: String?
    
    func displayMessageCenter() {
        displayMessageCenterCallCount += 1
    }
    
    var messageCenterTitle: String?
    
    func setMessageCenterStyle(_ style: [String : Any]) {
        setMessageCenterStyleCallCount += 1
    }
    
    
}
