//
//  AirshipSegmentation.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
import Airship
#else
import AirshipCore
#endif

public enum UATagType: String {
    
    case channel
    case namedUser = "named_user"
}

extension AirshipInstance {
    
    public var channelTags: [String]? {
        get {
            UAirship.channel()?.tags
        }
        
        set {
            guard let tags = newValue else {
                return
            }
            UAirship.channel()?.tags = tags
            UAirship.channel()?.updateRegistration()
        }
    }
    
    public func addTag(_ tagName: String) {
        UAirship.channel()?.addTag(tagName)
        UAirship.channel()?.updateRegistration()
    }
    
    public func removeTag(_ tagName: String) {
        UAirship.channel()?.removeTag(tagName)
        UAirship.channel()?.updateRegistration()
    }
    
    public func setNamedUserTags(_ group: String,
                            tags: [String]) {
        
        UAirship.namedUser()?.setTags(tags, group: group)
        UAirship.namedUser()?.updateTags()
    }
    
    public func addTagGroup(_ group: String,
                            tags: [String],
                            for tagType: UATagType) {
        
        switch tagType {
        case .channel:
            UAirship.channel()?.addTags(tags, group: group)
            UAirship.channel()?.updateRegistration()
        case .namedUser:
            UAirship.namedUser()?.addTags(tags, group: group)
            UAirship.namedUser()?.updateTags()
        }
    }
    
    public func removeTagGroup(_ group: String,
                               tags: [String],
                               for tagType: UATagType) {
        
        switch tagType {
        case .channel:
            UAirship.channel()?.removeTags(tags, group: group)
            UAirship.channel()?.updateRegistration()
        case .namedUser:
            UAirship.namedUser()?.removeTags(tags, group: group)
            UAirship.namedUser()?.updateTags()
        }
    }
    
    public func setAttributes(_ attributes: [String: Any]) {
        let mutations = UAAttributeMutations()
        attributes.forEach {
            switch $0.value {
            case let value as String:
                mutations.setString(value, forAttribute: $0.key)
            case let value as NSNumber:
                mutations.setNumber(value, forAttribute: $0.key)
            default:
                return
            }
        }
        UAirship.channel()?.apply(mutations)
    }

}
