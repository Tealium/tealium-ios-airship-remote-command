//
//  AirshipLocation.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

// Provides protocol conformance when location is disabled
extension AirshipTrackable {
    
    public var locationEnabled: Bool? {
        get {
            return nil
        }
        
        set {}
    }
    
    public var backgroundLocationEnabled: Bool? {
        get {
            return nil
        }
        
        set {}
    }
    
}
