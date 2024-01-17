//
//  BaseTabView.swift
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
            // MARK: - API Entries Tab

            ModularContainerView(
                store: apiStore,
                contentTitle: Constants.APIModule.title
            ) { apis in
                AnyView(APIEntriesView(apis: apis))
            }
            .tabItem {
                Label(
                    Constants.APIModule.title,
                    systemImage: Constants.APIModule.Symbol.tab.name
                )
            }
            .tag(1)

            // MARK: - Users Tab

            ModularContainerView(
                store: userStore,
                contentTitle: Constants.UserModule.title
            ) { users in
                AnyView(UserResultsView(users: users))
            }
            .tabItem {
                Label(
                    Constants.UserModule.title,
                    systemImage: Constants.UserModule.Symbol.tab.name
                )
            }
            .tag(2)

            // MARK: - Documents Tab

            DocumentsExplorer()
                .tabItem {
                    Label(
                        Constants.DocumentsModule.title,
                        systemImage: Constants.DocumentsModule.Symbol.tab.name
                    )
                }
                .tag(3)

            // MARK: - Settings Tab
            SettingsView()
                .tabItem {
                    Label(
                        Constants.SettingsModule.title,
                        systemImage: Constants.SettingsModule.Symbol.tab.name
                    )
                }
                .tag(4)
        }
    }
}

#Preview {
    BaseTabView()
}
