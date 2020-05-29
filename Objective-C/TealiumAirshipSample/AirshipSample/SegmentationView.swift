//
//  SegmentationView.swift
//  AirshipSample
//
//  Created by Craig Rouse on 17/04/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import SwiftUI

struct SegmentationView: View {
    var body: some View {
        VStack {
            TitleView().padding(.bottom, 15)
//            ScrollView {
            VStack(spacing: 15) {
                ButtonView(event: "setChannelTags")
                ButtonView(event: "setNamedUserTags")
                ButtonView(event: "addTag")
                ButtonView(event: "removeTag")
                ButtonView(event: "addTagGroup")
                ButtonView(event: "removeTagGroup")
                ButtonView(event: "setAttributes")
            }
//        }
            Spacer()
        }
    }
}

struct SegmentationView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentationView()
    }
}
