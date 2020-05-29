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
import Airship
#else
import AirshipCore
#endif

extension AirshipTracker {
       
       public func enableAdvertisingIDs() {
           // Get the current identifiers
            guard let identifiers = UAirship.analytics()?.currentAssociatedDeviceIdentifiers() else {
                return
            }
        
            identifiers.advertisingID = ASIdentifierManager.shared().advertisingIdentifier.uuidString;
            identifiers.advertisingTrackingEnabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled;
            identifiers.vendorID = UIDevice.current.identifierForVendor?.uuidString

            UAirship.analytics()?.associateDeviceIdentifiers(identifiers)
        
       }
       
       public var customIdentifiers: [String: String]? {
           get {
                UAirship.analytics()?.currentAssociatedDeviceIdentifiers().allIDs as? [String: String]
           }
           
           set {
               guard let customIdentifiers = newValue else {
                   return
               }
                guard let identifiers = UAirship.analytics()?.currentAssociatedDeviceIdentifiers() else {
                    return
                }
               customIdentifiers.forEach {
                   identifiers.setIdentifier($0.key, forKey: $0.value)
               }
               UAirship.analytics()?.associateDeviceIdentifiers(identifiers)
           }
           
       }
       
       public func identifyUser(id: String) {
           UAirship.namedUser()?.identifier = id
       }
       
       public func trackScreenView(_ screenName: String) {
            UAirship.analytics()?.trackScreen(screenName)
       }
       
       public func trackEvent(_ eventName: String,
                              value: Float64? = nil,
                              eventProperties: [String: Any]?) {
           var event: UACustomEvent
           
           if let value = value {
               event = UACustomEvent(name: eventName, value: NSNumber(value: value))
           } else {
               event = UACustomEvent(name: eventName)
           }
           
            if let eventProperties = eventProperties {
                event.properties = eventProperties
            }
           
            event.track()
       }
       
       public var analyticsEnabled: Bool? {
           get {
               return UAirship.analytics()?.isEnabled
           }
           
           set {
               guard let enabled = newValue else {
                   return
               }
               UAirship.analytics()?.isEnabled = enabled
           }
       }
}
