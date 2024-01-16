//
//  SettingsView.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(Constants.KeyName.apiToken) private var userAPIKey = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Image(.prowlr)

            Text("Pic PrOWLr requires a valid \nPexels API key")
                .foregroundStyle(.prowlrBlue)
                .font(Constants.Fonts.generalFont)
                .multilineTextAlignment(.center)
                .padding()

            TextField("Your Pexels API Key", text: $userAPIKey)
                .textFieldStyle(.plain)
                .padding()
                .background(Material.thin)
                .mask(RoundedRectangle(cornerRadius: Constants.Styling.cornerRadiusLarge))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal)

            Button(
                action: { dismiss() },
                label: {
                    Text("start prowling")
                        .foregroundStyle(.prowlrViolet)
                        .padding()
                        .background(userAPIKey.isEmpty ? .prowlrPurple : .prowlrBlue)
                        .mask(RoundedRectangle(cornerRadius: Constants.Styling.cornerRadiusLarge))
                }
            )
            .disabled(userAPIKey.isEmpty)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { ProwlrGradient() }

        .navigationTitle("API Key")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
