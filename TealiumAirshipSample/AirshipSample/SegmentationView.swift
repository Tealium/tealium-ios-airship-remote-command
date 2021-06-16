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
            VStack(spacing: 15) {
                ButtonView(event: "setChannelTags", Tags.channel.dictionary)
                ButtonView(event: "setNamedUserTags", Tags.namedUser.dictionary)
                ButtonView(event: "addTag", ["channel_tag": "abc567"])
                ButtonView(event: "removeTag", ["channel_tag": "abc567"])
                ButtonView(event: "addTagGroup", Tags.namedUser.dictionary)
                ButtonView(event: "removeTagGroup", Tags.namedUser.dictionary)
                ButtonView(event: "setAttributes", Customer.default.dictionary)
            }
            Spacer()
        }
    }
}

struct SegmentationView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentationView()
    }
}
