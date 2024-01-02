//
//  APIEntriesView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct APIEntriesView: View {
    private let sortedAPIs: [APIEntry]

    init(apis: [APIEntry]) {
        self.sortedAPIs = apis.sorted(by: { $0.api < $1.api })
    }

    var body: some View {
        List(sortedAPIs) { apiEntry in
            NavigationLink {
                APIEntryDetailView(apiEntry: apiEntry)
            } label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text(apiEntry.api)
                            .bold()
                        Spacer()
                        featureTags(for: apiEntry)
                    }
                    Text(apiEntry.description)
                        .font(.footnote)
                }
            }
        }
    }

    // MARK: - Supporting Views
    func featureTags(for apiEntry: APIEntry) -> some View {
        let auth = apiEntry.auth?.trimmingCharacters(in: .whitespaces) ?? ""
        return HStack {
            if apiEntry.https == true {
                PillTag(text: "HTTPS", color: .green)
            }
            if apiEntry.cors == .yes {
                PillTag(text: "CORS", color: .green)
            }
            if auth.count > 1 {
                PillTag(text: auth, color: .blue)
            }
        }
    }
}

#Preview {
    NavigationStack {
        APIEntriesView(apis: [.axolotl, .circleCI])
    }
}
