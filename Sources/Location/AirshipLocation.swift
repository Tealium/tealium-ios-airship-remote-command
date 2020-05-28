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
            UALocation.shared()?.isLocationUpdatesEnabled
        }
        
        set {
            guard let locationEnabled = newValue else {
                return
            }
            UALocation.shared()?.isLocationUpdatesEnabled = locationEnabled
        }
    }
    
    public var backgroundLocationEnabled: Bool? {
        get {
            UALocation.shared()?.isBackgroundLocationUpdatesAllowed
        }
        
        set {
            guard let backgroundLocationEnabled = newValue else {
                return
            }
            UALocation.shared()?.isBackgroundLocationUpdatesAllowed = backgroundLocationEnabled
        }
    }
    
}
