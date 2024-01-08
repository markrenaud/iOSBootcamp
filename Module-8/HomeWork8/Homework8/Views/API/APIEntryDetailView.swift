//
//  APIEntryDetailView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

/// A view that displays detailed information about an API entry.
struct APIEntryDetailView: View {
    let apiEntry: APIEntry
    
    var body: some View {
        Form {
            Section("Description") {
                Text(apiEntry.description)
            }
            Section("Category") {
                Text(apiEntry.category)
            }
            Section("API Link") {
                Link(destination: apiEntry.link, label: {
                    Label(
                        apiEntry.link.absoluteString,
                        systemImage: "link"
                    )
                })
            }
            Section("Features") {
                labeledAuthRow(apiEntry)
                labeledHTTPSRow(apiEntry)
                labeledCORSRow(apiEntry)
            }
        }
        .navigationTitle(apiEntry.api)
    }
    
    /// Creates a view with a label and a pill tag for the given text and color.
    func labeledPillTag(_ label: String, pillText: String, pillColor: Color) -> some View {
        HStack {
            Text(label)
            Spacer()
            PillTag(text: pillText, color: pillColor)
        }
    }
    
    /// Creates a view for the authentication feature of the API entry.
    func labeledAuthRow(_ apiEntry: APIEntry) -> some View {
        let authString = apiEntry.auth?.trimmingCharacters(in: .whitespaces) ?? ""
        switch authString {
        case "":
            return labeledPillTag("Auth", pillText: "none", pillColor: .gray)
        default:
            return labeledPillTag("Auth", pillText: authString, pillColor: .blue)
        }
    }
    
    /// Creates a view for the HTTPS feature of the API entry.
    func labeledHTTPSRow(_ apiEntry: APIEntry) -> some View {
        switch apiEntry.https {
        case true:
            return labeledPillTag("HTTPS", pillText: "Yes", pillColor: .green)
        case false:
            return labeledPillTag("HTTPS", pillText: "No", pillColor: .red)
        }
    }
    
    /// Creates a view for the CORS feature of the API entry.
    func labeledCORSRow(_ apiEntry: APIEntry) -> some View {
        switch apiEntry.cors {
        case .yes:
            return labeledPillTag("CORS", pillText: "Yes", pillColor: .green)
        case .no:
            return labeledPillTag("CORS", pillText: "No", pillColor: .red)
        case .unknown:
            return labeledPillTag("CORS", pillText: "Unknown", pillColor: .gray)
        }
    }
}

#Preview {
    NavigationStack {
        APIEntryDetailView(apiEntry: .axolotl)
    }
}
