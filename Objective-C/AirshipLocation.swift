//
//  AirshipLocation.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

#if COCOAPODS
import Airship
#else
import AirshipLocation
#endif

extension AirshipTracker {
    
    public var locationEnabled: Bool? {
        get {
            #if canImport(AirshipLocation)
            return UALocation.shared().isLocationUpdatesEnabled
            #else
            return nil
            #endif
        }
        
        set {
            guard let locationEnabled = newValue else {
                return
            }
            #if canImport(AirshipLocation)
            return UALocation.shared().isLocationUpdatesEnabled = locationEnabled
            #endif
        }
    }
    
    public var backgroundLocationEnabled: Bool? {
        get {
            #if canImport(AirshipLocation)
            return UALocation.shared().isBackgroundLocationUpdatesAllowed
            #else
            return nil
            #endif
        }
        
        set {
            guard let backgroundLocationEnabled = newValue else {
                return
            }
            #if canImport(AirshipLocation)
            return UALocation.shared().isBackgroundLocationUpdatesAllowed = backgroundLocationEnabled
            #endif
        }
    }
    
}
