//
//  ContentView.swift
//  Colordle
//
//  Created by Riley Koo on 5/16/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Daily", systemImage: "calendar") {
                DailyView()
            }
            Tab("Infinite", systemImage: "infinity") {
                InfiniteView()
            }
        }
    }
}

#Preview {
    ContentView()
}
