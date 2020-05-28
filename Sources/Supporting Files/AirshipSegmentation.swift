//
//  AirshipSegmentation.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 24/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
import AirshipKit
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
            Airship.channel.tags
        }
        
        set {
            guard let tags = newValue else {
                return
            }
            Airship.channel.tags = tags
            Airship.channel.updateRegistration()
        }
    }
    
    public func addTag(_ tagName: String) {
        Airship.channel.editTags({ editor in
            editor.add(tagName)
        })
        Airship.channel.updateRegistration()
    }
    
    public func removeTag(_ tagName: String) {
        Airship.channel.editTags({ editor in
            editor.remove(tagName)
        })
        Airship.channel.updateRegistration()
    }
    
    public func setNamedUserTags(_ group: String,
                            tags: [String]) {
        Airship.contact.editTagGroups({ editor in
            editor.add(tags, group: group)
        })
    }
    
    public func addTagGroup(_ group: String,
                            tags: [String],
                            for tagType: UATagType) {
        
        switch tagType {
        case .channel:
            Airship.channel.editTagGroups({ editor in
                editor.add(tags, group: group)
            })
            Airship.channel.updateRegistration()
        case .namedUser:
            Airship.contact.editTagGroups({ editor in
                editor.add(tags, group: group)
            })
        }
    }
    
    public func removeTagGroup(_ group: String,
                               tags: [String],
                               for tagType: UATagType) {
        
        switch tagType {
        case .channel:
            Airship.channel.editTagGroups({ editor in
                editor.remove(tags, group: group)
            })
            Airship.channel.updateRegistration()
        case .namedUser:
            Airship.contact.editTagGroups({ editor in
                editor.remove(tags, group: group)
            })
        }
    }
    
    public func setAttributes(_ attributes: [String: Any]) {
        Airship.channel.editAttributes({ editor in
            attributes.forEach {
                switch $0.value {
                case let value as String:
                    editor.set(string: value, attribute: $0.key)
                case let value as NSNumber:
                    editor.set(number: value, attribute: $0.key)
                default:
                    return
                }
            }
            editor.apply()
        })
    }

}
