//
//  DownloadStateSymbolView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(Constants.PreferenceKey.resources) private var preferencesData: Data = [ResourcePreference].defaults.jsonData()
    @AppStorage(Constants.PreferenceKey.cache) private var autoCache: Bool = true
    @State private var editMode = EditMode.active

    var preferences: Binding<[ResourcePreference]> {
        Binding {
            [ResourcePreference].from(json: preferencesData) ?? .defaults
        } set: { newPreferences in
            preferencesData = newPreferences.jsonData()
        }
    }
    
    var body: some View {
        Form {
            Section("Data Source Order Preference") {
                List(preferences, editActions: [.move]) { $preference in
                    HStack {
                        Image(systemName: preference.enabled ? "checkmark.circle.fill" : "circle")
                            .font(.largeTitle)
                            .foregroundStyle(preference.enabled ? .green : .gray.opacity(0.3))
                            .onTapGesture {
                                preference.enabled.toggle()
                            }
                        
                        Text(preference.title)
                    }
                }
                Text("Customize the sequence and availability of sources for fetching JSON.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Section("Cache") {
                Toggle("Cache Remote", isOn: $autoCache)
                Text("Switch on to preserve downloaded JSON in Documents directory.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .environment(\.editMode, $editMode)
        .padding()
    }

    
}

#Preview {
    SettingsView()
}
