//
//  AirshipConfig.swift
//  TealiumAirship+Location
//
//  Created by Craig Rouse on 23/03/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
import AirshipKit
#else
import AirshipCore
#endif

enum UAConfigKeys: String {
    
    case productionAppKey
    case productionAppSecret
    case developmentAppKey
    case developmentAppSecret
    case site
    case isDataCollectionOptInEnabled
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

extension CloudSite {
    init(_ site: String) {
        self = (site.lowercased() == "eu") ? .eu : .us
    }
}

extension LogLevel {
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

extension Config {
    
    static func initWithDictionary(_ config: [String: Any]) -> Config {
        let newConfig = Config()
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
                        newConfig.site = CloudSite(value)
                    }
                case .isInProduction:
                    if let value = item.value as? Bool {
                        newConfig.inProduction = value
                    }
                case .developmentLogLevel:
                    if let value = item.value as? String {
                        newConfig.developmentLogLevel = LogLevel(value)
                    }
                case .productionLogLevel:
                    if let value = item.value as? String {
                        newConfig.productionLogLevel = LogLevel(value)
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
