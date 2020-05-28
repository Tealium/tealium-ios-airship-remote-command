//
//  TitleView.swift
//  AirshipSample
//
//  Created by Craig Rouse on 17/04/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
         HStack {
            Text("TealiumAirshipSample")
             .frame(maxWidth: .infinity, alignment: .center)
             .font(.custom("HelveticaNeue", size: 22.0))
        }.padding()
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
