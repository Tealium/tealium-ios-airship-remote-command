//
//  AirshipMessageCenter.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 27/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
import AirshipKit
#else
import AirshipCore
import AirshipMessageCenter
#endif

enum InternalMessageCenterStyle: String {
    case titleFont
    case cellTitleFont
    case cellDateFont
    case navigationBarColor
    case titleColor
    case tintColor
    case red
    case blue
    case green
    case alpha
    case name
    case size
}

extension AirshipInstance {

    public func displayMessageCenter() {
        DispatchQueue.main.async {
            MessageCenter.shared.display()
        }
    }
    
    public var messageCenterTitle: String? {
        get {
            MessageCenter.shared.defaultUI.title
        }
        
        set {
            guard let title = newValue else {
                return
            }
            MessageCenter.shared.defaultUI.title = title
        }
    }

    public func setMessageCenterStyle(_ style: [String : Any]) {
        let messageCenterStyle = MessageCenterStyle()
        
        if let titleFont = style[InternalMessageCenterStyle.titleFont.rawValue] as? [String: Any] {
            guard let size = titleFont[InternalMessageCenterStyle.size.rawValue] as? Double,
                let fontName = titleFont[InternalMessageCenterStyle.name.rawValue] as? String else {
                return
            }
            messageCenterStyle.titleFont = UIFont(name: fontName, size: CGFloat(size))
        }
        
        if let cellTitleFont = style[InternalMessageCenterStyle.cellTitleFont.rawValue] as? [String: Any] {
            guard let size = cellTitleFont[InternalMessageCenterStyle.size.rawValue] as? Double,
                let fontName = cellTitleFont[InternalMessageCenterStyle.name.rawValue] as? String else {
                return
            }
            messageCenterStyle.cellTitleFont = UIFont(name: fontName, size: CGFloat(size))
        }
        
        if let cellDateFont = style[InternalMessageCenterStyle.cellDateFont.rawValue] as? [String: Any] {
            guard let size = cellDateFont[InternalMessageCenterStyle.size.rawValue] as? Double,
                let fontName = cellDateFont[InternalMessageCenterStyle.name.rawValue] as? String else {
                return
            }
            messageCenterStyle.cellDateFont = UIFont(name: fontName, size: CGFloat(size))
        }
        
        if let navigationBarColor = style[InternalMessageCenterStyle.navigationBarColor.rawValue] as? [String: Any] {
            guard let red = navigationBarColor[InternalMessageCenterStyle.red.rawValue] as? Double,
                let green = navigationBarColor[InternalMessageCenterStyle.green.rawValue] as? Double,
                let blue = navigationBarColor[InternalMessageCenterStyle.blue.rawValue] as? Double,
                let alpha = navigationBarColor[InternalMessageCenterStyle.alpha.rawValue] as? Double else {
                return
            }
            
            messageCenterStyle.navigationBarColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }
        
        if let titleColor = style[InternalMessageCenterStyle.titleColor.rawValue] as? [String: Any] {
            guard let red = titleColor[InternalMessageCenterStyle.red.rawValue] as? Double,
                let green = titleColor[InternalMessageCenterStyle.green.rawValue] as? Double,
                let blue = titleColor[InternalMessageCenterStyle.blue.rawValue] as? Double,
                let alpha = titleColor[InternalMessageCenterStyle.alpha.rawValue] as? Double else {
                return
            }
            
            messageCenterStyle.titleColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }
        
        if let tintColor = style[InternalMessageCenterStyle.tintColor.rawValue] as? [String: Any] {
            guard let red = tintColor[InternalMessageCenterStyle.red.rawValue] as? Double,
                let green = tintColor[InternalMessageCenterStyle.green.rawValue] as? Double,
                let blue = tintColor[InternalMessageCenterStyle.blue.rawValue] as? Double,
                let alpha = tintColor[InternalMessageCenterStyle.alpha.rawValue] as? Double else {
                return
            }
            
            messageCenterStyle.tintColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }
        
        MessageCenter.shared.defaultUI.messageCenterStyle = messageCenterStyle
        
    }
}
