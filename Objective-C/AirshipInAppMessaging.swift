//
//  AirshipInAppMessaging.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

// Comment out if using Carthage
import Airship

// Uncomment if using Carthage
//import AirshipCore
//import AirshipAutomation

extension AirshipTracker {
    
    public var inAppMessagingEnabled: Bool? {
        get {
            UAInAppMessageManager.shared()?.isEnabled
        }
        
        set {
            guard let enabled = newValue else {
                return
            }
            UAInAppMessageManager.shared()?.isEnabled = enabled
        }
    }
    
    public var inAppMessagingPaused: Bool?  {
           get {
               UAInAppMessageManager.shared()?.isPaused
           }
           
           set {
               guard let paused = newValue else {
                   return
               }
               UAInAppMessageManager.shared()?.isPaused = paused
           }
       }
    
    public var inAppMessagingDisplayInterval: String?  {
           get {
            UAInAppMessageManager.shared()?.displayInterval.description
           }
           
           set {
               guard let intervalString = newValue,
                let interval = TimeInterval(intervalString) else {
                   return
               }
               UAInAppMessageManager.shared()?.displayInterval = interval
           }
       }
    
}
