//
//  ContentView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct BaseTabView: View {
    @State private var selected: Int = 1

    @StateObject private var apiStore = ModularStore(
        initialCodable: APIEntries.empty,
        projectedKeyPath: \APIEntries.entries
    )

    @StateObject private var userStore = ModularStore(
        initialCodable: UserResults.empty,
        projectedKeyPath: \UserResults.users
    )

    var body: some View {
        TabView(selection: $selected) {
            ModularContainerView(
                store: apiStore,
                contentTitle: "APIs",
                jsonFile: .apis,
                jsonSearchDirectories: [.mainBundle, .userDocuments]
            ) { apis in
                AnyView(APIEntriesView(apis: apis))
            }
            .tabItem {
                Label("APIs", systemImage: Constants.Symbols.apiTab.name)
            }
            .tag(1)

            ModularContainerView(
                store: userStore,
                contentTitle: "Users",
                jsonFile: .users,
                jsonSearchDirectories: [.mainBundle, .userDocuments]
            ) { users in
                AnyView(UserResultsView(users: users))
            }

            .tabItem {
                Label("Users", systemImage: Constants.Symbols.userTab.name)
            }
            .tag(2)

            DocumentsExplorer()
                .tabItem {
                    Label("Docs", systemImage: Constants.Symbols.documentsTab.name)
                }
                .tag(3)
        }
    }
}

#Preview {
    BaseTabView()
}
