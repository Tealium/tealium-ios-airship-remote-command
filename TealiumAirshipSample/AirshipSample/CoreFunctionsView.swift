//
//  StandardView.swift
//  AirshipSample
//
//  Created by Craig Rouse on 17/04/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import SwiftUI

struct CoreFunctionsView: View {
    var body: some View {
        VStack {
            TitleView().padding(.bottom, 15)
            VStack(spacing: 15) {
                ButtonView(event: "initialize", ["log_level": "debug"])
                ButtonView(event: "trackEvent", ["event_name": "button_click", "event_value": 12, "event_description": "reserve_seats"])
                ButtonView(event: "purchase", Purchase.default.dictionary)
                ButtonView(event: "trackScreenView", ["screen_name": "CoreFunctionsView"])
                ButtonView(event: "setCustomIdentifiers", ["customer_id": "ABC123"])
                ButtonView(event: "setNamedUser", ["username": "bob.dylan"])
            }
            Spacer()
        }
    }
}

struct CoreFunctionsView_Previews: PreviewProvider {
    static var previews: some View {
        CoreFunctionsView()
    }
}
