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
                ButtonView(event: "trackEvent")
                ButtonView(event: "trackScreenView")
                ButtonView(event: "setCustomIdentifiers")
                ButtonView(event: "setNamedUser")
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
