//
//  AirshipAnalytics.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import AdSupport
#if COCOAPODS
import AirshipKit
#else
import AirshipCore
#endif

extension AirshipInstance {
       
       public func enableAdvertisingIDs() {
           // Get the current identifiers
            let identifiers = Airship.analytics.currentAssociatedDeviceIdentifiers()
            identifiers.advertisingID = ASIdentifierManager.shared().advertisingIdentifier.uuidString;
            identifiers.advertisingTrackingEnabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled;
            identifiers.vendorID = UIDevice.current.identifierForVendor?.uuidString

           Airship.analytics.associateDeviceIdentifiers(identifiers)
        
       }
       
       public var customIdentifiers: [String: String]? {
           get {
               Airship.analytics.currentAssociatedDeviceIdentifiers().allIDs
           }
           
           set {
               guard let customIdentifiers = newValue else {
                   return
               }
                let identifiers = Airship.analytics.currentAssociatedDeviceIdentifiers()
               customIdentifiers.forEach {
                   identifiers.set(identifier: $0.key, key: $0.value)
               }
               Airship.analytics.associateDeviceIdentifiers(identifiers)
           }
           
       }
       
       public func identifyUser(id: String) {
           Airship.contact.identify(id)
       }
       
       public func trackScreenView(_ screenName: String) {
           Airship.analytics.trackScreen(screenName)
       }
       
       public func trackEvent(_ eventName: String,
                              value: Float64? = nil,
                              eventProperties: [String: Any]?) {
           var event: CustomEvent
           
           if let value = value {
               event = CustomEvent(name: eventName, value: NSNumber(value: value))
           } else {
               event = CustomEvent(name: eventName)
           }
           
            if let eventProperties = eventProperties {
                event.properties = eventProperties
            }
           
            event.track()
       }
       
       public var analyticsEnabled: Bool? {
           get {
               return Airship.analytics.isComponentEnabled
           }
           
           set {
               guard let enabled = newValue else {
                   return
               }
               Airship.analytics.isComponentEnabled = enabled
           }
       }
}
