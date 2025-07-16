//
//  ContentView.swift
//  SwiftPlayground
//
//  Created by Raymond Truong on 7/15/25.
//

import SwiftUI

enum Tabs: String, CaseIterable {
    case observationDemo
}

struct ContentView: View {
    @State var selectedTab: Tabs = .observationDemo

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tabs.allCases, id: \.self) { tab in
                Tab(
                    tab.rawValue.capitalized,
                    systemImage: "swift",
                    value: tab
                ) {
                    switch tab {
                    case .observationDemo:
                        ObservationDemo()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
