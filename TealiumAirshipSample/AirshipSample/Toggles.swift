//
//  Toggles.swift
//  AirshipSample
//
//  Created by Craig Rouse on 17/04/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import SwiftUI

struct Toggles: View {
    var body: some View {
        VStack {
            TitleView().padding(.bottom, 15)
            ScrollView {
                VStack(spacing: 15) {
                                ButtonView(event: "enableAnalytics")
                                ButtonView(event: "disableAnalytics")
                                ButtonView(event: "enableAdvertisingIdentifiers")
                                ButtonView(event: "enableInAppMessaging")
                                ButtonView(event: "disableInAppMessaging")
                                ButtonView(event: "pauseInAppMessaging")
                                ButtonView(event: "unpauseInAppMessaging")
                    ButtonView(event: "enableUserPushNotifications", ["options": ["sound", "alert", "badge"]])
                                ButtonView(event: "disableUserPushNotifications")
                                ButtonView(event: "enableBackgroundPushNotifications")
                            }
                Spacer()
                VStack(spacing: 15){
                                ButtonView(event: "disableBackgroundPushNotifications")
                                ButtonView(event: "enableAutoBadge")
                                ButtonView(event: "disableAutoBadge")
                                ButtonView(event: "enableQuietTime")
                                ButtonView(event: "disableQuietTime")
                                ButtonView(event: "enableLocation")
                                ButtonView(event: "disableLocation")
                                ButtonView(event: "enableBackgroundLocation")
                                ButtonView(event: "disableBackgroundLocation")
                }
            }
            Spacer()
        }
    }
}

struct Toggles_Previews: PreviewProvider {
    static var previews: some View {
        Toggles()
    }
}
