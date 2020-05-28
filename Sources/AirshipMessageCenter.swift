//
//  AirshipMessageCenter.swift
//  TealiumAirship
//
//  Created by Craig Rouse on 27/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

#if COCOAPODS
import Airship
#else
import AirshipCore
import AirshipMessageCenter
#endif


enum MessageCenterStyle: String {
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

extension AirshipTracker {

    public func displayMessageCenter() {
        DispatchQueue.main.async {
            UAMessageCenter.shared()?.display()
        }
    }
    
    public var messageCenterTitle: String? {
        get {
            return UAMessageCenter.shared()?.defaultUI.title
        }
        
        set {
            guard let title = newValue else {
                return
            }
            UAMessageCenter.shared()?.defaultUI.title = title
        }
    }
/*
     
     ["titleFont": ["size": Double, "name":"fontname"],
     "cellTitleFont": ["size": Double, "name":"fontname"],
     "cellDateFont": ["size": Double, "name":"fontname"],
     "navigationBarColor": ["red": Double, "green": Double, "blue": Double, "alpha": Double]
     "titleColor": ["red": Double, "green": Double, "blue": Double, "alpha": Double]
     "tintColor": ["red": Double, "green": Double, "blue": Double, "alpha": Double]
     ]
     */
    public func setMessageCenterStyle(_ style: [String : Any]) {
        let messageCenterStyle = UAMessageCenterStyle()
        
        if let titleFont = style[MessageCenterStyle.titleFont.rawValue] as? [String: Any] {
            guard let size = titleFont[MessageCenterStyle.size.rawValue] as? Double,
                let fontName = titleFont[MessageCenterStyle.name.rawValue] as? String else {
                return
            }
            messageCenterStyle.titleFont = UIFont(name: fontName, size: CGFloat(size))
        }
        
        if let cellTitleFont = style[MessageCenterStyle.cellTitleFont.rawValue] as? [String: Any] {
            guard let size = cellTitleFont[MessageCenterStyle.size.rawValue] as? Double,
                let fontName = cellTitleFont[MessageCenterStyle.name.rawValue] as? String else {
                return
            }
            messageCenterStyle.cellTitleFont = UIFont(name: fontName, size: CGFloat(size))
        }
        
        if let cellDateFont = style[MessageCenterStyle.cellDateFont.rawValue] as? [String: Any] {
            guard let size = cellDateFont[MessageCenterStyle.size.rawValue] as? Double,
                let fontName = cellDateFont[MessageCenterStyle.name.rawValue] as? String else {
                return
            }
            messageCenterStyle.cellDateFont = UIFont(name: fontName, size: CGFloat(size))
        }
        
        if let navigationBarColor = style[MessageCenterStyle.navigationBarColor.rawValue] as? [String: Any] {
            guard let red = navigationBarColor[MessageCenterStyle.red.rawValue] as? Double,
                let green = navigationBarColor[MessageCenterStyle.green.rawValue] as? Double,
                let blue = navigationBarColor[MessageCenterStyle.blue.rawValue] as? Double,
                let alpha = navigationBarColor[MessageCenterStyle.alpha.rawValue] as? Double else {
                return
            }
            
            messageCenterStyle.navigationBarColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }
        
        if let titleColor = style[MessageCenterStyle.titleColor.rawValue] as? [String: Any] {
            guard let red = titleColor[MessageCenterStyle.red.rawValue] as? Double,
                let green = titleColor[MessageCenterStyle.green.rawValue] as? Double,
                let blue = titleColor[MessageCenterStyle.blue.rawValue] as? Double,
                let alpha = titleColor[MessageCenterStyle.alpha.rawValue] as? Double else {
                return
            }
            
            messageCenterStyle.titleColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }
        
        if let tintColor = style[MessageCenterStyle.tintColor.rawValue] as? [String: Any] {
            guard let red = tintColor[MessageCenterStyle.red.rawValue] as? Double,
                let green = tintColor[MessageCenterStyle.green.rawValue] as? Double,
                let blue = tintColor[MessageCenterStyle.blue.rawValue] as? Double,
                let alpha = tintColor[MessageCenterStyle.alpha.rawValue] as? Double else {
                return
            }
            
            messageCenterStyle.tintColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        }
        
        UAMessageCenter.shared()?.defaultUI.style = messageCenterStyle
        
    }
}
