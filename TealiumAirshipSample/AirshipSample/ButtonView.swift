//
//  ButtonView.swift
//  AirshipSample
//
//  Created by Craig Rouse on 17/04/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import SwiftUI

struct ButtonView: View {
    var title: String
    var data: [String: Any]?
    
    init(event title: String,
         _ data: [String: Any]? = nil) {
        self.title = title
        guard let data = data else { return }
        self.data = data
    }
    
    var body: some View {
        Button(action: {
            let eventName = self.title.replacingOccurrences(of: " ", with: "").lowercased()
            TealiumHelper.trackEvent(title: eventName,
                                     data: self.data)
        }) {
           Text(title)
               .frame(width: 200.0)
               .padding()
               .background(Color.gray)
               .foregroundColor(.white)
               .cornerRadius(10)
               .shadow(radius: 8)
               .overlay(
                   RoundedRectangle(cornerRadius: 10)
                       .stroke(Color.purple, lineWidth: 2)
               )
               
       }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(event: "test")
    }
}
