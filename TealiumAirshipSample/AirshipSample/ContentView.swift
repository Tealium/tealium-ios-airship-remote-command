//
//  ContentView.swift
//  AirshipSample
//
//  Created by Craig Rouse on 17/04/2020.
//  Copyright © 2020 Tealium. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            CoreFunctionsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Core Functions")
                }.tag(0)
            MessagingView()
            .tabItem {
                Image(systemName: "quote.bubble.fill")
                Text("Messaging")
            }.tag(1)
            SegmentationView()
            .tabItem {
                Image(systemName: "divide.square.fill")
                Text("Segmentation")
            }.tag(2)
            Toggles()
                .tabItem {
                    Image(systemName: "power")
                    Text("Feature Toggles")
                }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
