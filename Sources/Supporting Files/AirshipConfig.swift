//
//  AirshipConfig.swift
//  TealiumAirship+Location
//
//  Created by Craig Rouse on 23/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import Airship

enum UAConfigKeys: String {
    
    case productionAppKey
    case productionAppSecret
    case developmentAppKey
    case developmentAppSecret
    case site
    case isDataCollectionOptInEnabled
    case isDataCollectionEnabled
    case isInProduction
    case developmentLogLevel
    case productionLogLevel
    case isAnalyticsEnabled
    case analyticsURL
    case appKey
    case appSecret
    case clearUserOnAppRestore
    case clearNamedUserOnAppRestore
    case customConfig
    case detectProvisioningMode
    case deviceAPIURL
    case isAutomaticSetupEnabled
    case isChannelCaptureEnabled
    case isChannelCreationDelayEnabled
    case isOpenURLWhitelistingEnabled
    case itunesID
    case logLevel
    case messageCenterStyleConfig
    case remoteDataAPIURL
    case requestAuthorizationToUseNotifications
}

extension UACloudSite {
    init(_ site: String) {
        self = (site.lowercased() == "eu") ? .EU : .US
    }
}

extension UALogLevel {
    init(_ logLevel: String) {
        switch logLevel {
        case "debug":
            self = .debug
        case "error":
            self = .error
        case "info":
            self = .info
        case "none":
        self = .none
        case "trace":
        self = .trace
        case "undefined":
            self = .undefined
        case "warn":
            self = .warn
        default:
            self = .error
        }
    }
}

extension UAConfig {
    
    static func initWithDictionary(_ config: [String: Any]) -> UAConfig {
        let newConfig = UAConfig()
        config.forEach { item in
            if let configKey = UAConfigKeys(rawValue: item.key) {
                switch configKey {
                case .productionAppSecret:
                    if let value = item.value as? String {
                        newConfig.productionAppSecret = value
                    }
                case .productionAppKey:
                    if let value = item.value as? String {
                        newConfig.productionAppKey = value
                    }
                case .developmentAppSecret:
                    if let value = item.value as? String {
                        newConfig.developmentAppSecret = value
                    }
                case .developmentAppKey:
                    if let value = item.value as? String {
                        newConfig.developmentAppKey = value
                    }
                case .site:
                    if let value = item.value as? String {
                        newConfig.site = UACloudSite(value)
                    }
                case .isDataCollectionOptInEnabled:
                    if let value = item.value as? Bool {
                        newConfig.isDataCollectionOptInEnabled = value
                    }
                case .isInProduction:
                    if let value = item.value as? Bool {
                        newConfig.isInProduction = value
                    }
                case .developmentLogLevel:
                    if let value = item.value as? String {
                        newConfig.developmentLogLevel = UALogLevel(value)
                    }
                case .productionLogLevel:
                    if let value = item.value as? String {
                        newConfig.productionLogLevel = UALogLevel(value)
                    }
                case .isAnalyticsEnabled:
                    if let value = item.value as? Bool {
                        newConfig.isAnalyticsEnabled = value
                    }
                default:
                    return
                }
            }
        }
        return newConfig
    }
}
