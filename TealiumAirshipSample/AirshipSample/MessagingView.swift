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
                ButtonView(event: "setInAppMessagingDisplayInterval")
                ButtonView(event: "setPushNotificationOptions")
                ButtonView(event: "setForegroundPresentationOptions")
                ButtonView(event: "setBadgeNumber")
                ButtonView(event: "resetBadgeNumber")
                ButtonView(event: "setQuietTimeStart")
                ButtonView(event: "displayMessageCenter")
                ButtonView(event: "setMessageCenterTitle")
                ButtonView(event: "setMessageCenterStyle")
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
