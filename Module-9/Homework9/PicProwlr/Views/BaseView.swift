//
//  BaseView.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

struct BaseView: View {
    @State private var searchStore = SearchStore()
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            SearchView()
                .onAppear {
                    // Check if the SearchStore can access the Pexels API
                    // token - show the setting screen if it cannot.
                    if searchStore.emptyToken {
                        showSettings = true
                    }
                }
        }
        .environment(searchStore)
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    BaseView()
}
