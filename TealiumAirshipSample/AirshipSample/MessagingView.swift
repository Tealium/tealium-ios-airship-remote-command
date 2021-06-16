//
//  MessagingView.swift
//  AirshipSample
//
//  Created by Craig Rouse on 17/04/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import SwiftUI

struct MessagingView: View {
    var body: some View {
        VStack {
            TitleView().padding(.bottom, 15)
            ScrollView {
            VStack(spacing: 15) {
                ButtonView(event: "setInAppMessagingDisplayInterval", ["interval": "30"])
                ButtonView(event: "setPushNotificationOptions", ["options": ["badge"]])
                ButtonView(event: "setForegroundPresentationOptions", ["options": ["banner"]])
                ButtonView(event: "setBadgeNumber", ["badge_number": 5])
                ButtonView(event: "resetBadgeNumber")
                ButtonView(event: "setQuietTimeStart", ["quiet_start_hour": 20, "quiet_start_minute": 30, "quiet_end_hour": 08, "quiet_end_minute": 30])
                ButtonView(event: "displayMessageCenter")
                ButtonView(event: "setMessageCenterTitle", ["message_title": "Go Teal"])
                ButtonView(event: "setMessageCenterStyle", ["message_style": MessageStyle.default])
            }
        }
            Spacer()
        }
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView()
    }
}
