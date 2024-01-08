//
//  SimpleForm.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

/// A view that displays a form with a list of sections.
struct SimpleForm: View {
    let sections: [SimpleFormSection]
    var body: some View {
        Form {
            ForEach(sections.indices, id: \.self) { index in
                let section = sections[index]
                section
            }
        }
    }
}

/// A view that displays a section in a form with an optional header label and a list of rows.
struct SimpleFormSection: View {
    let label: String?
    let rows: [AnyView]
    init(_ label: String? = nil, rows: [any View]) {
        self.label = label
        self.rows = rows.map { AnyView($0) }
    }

    var body: some View {
        if let label {
            Section(label) {
                ForEach(rows.indices, id: \.self) { index in
                    rows[index]
                }
            }
        } else {
            Section {
                ForEach(rows.indices, id: \.self) { index in
                    rows[index]
                }
            }
        }
    }
}

/// A view that displays a row with a label and an optional detail text.
struct SimpleLabeledRow: View {
    let label: String
    let detail: String?

    init(label: String, detail: String? = nil) {
        self.label = label
        self.detail = detail
    }

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            if let detail {
                Text(detail)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

/// A view that displays a row with a label, an optional detail text, and navigates to a destination
/// view when tapped.
struct SimpleDestinationRow<DView: View>: View {
    let label: String
    let detail: String?
    let destination: DView

    init(label: String, detail: String? = nil, destination: DView) {
        self.label = label
        self.detail = detail
        self.destination = destination
    }

    @ViewBuilder
    var body: some View {
        NavigationLink {
            destination
                .navigationTitle(label)
        } label: {
            SimpleLabeledRow(label: label, detail: detail)
        }
    }
}

#Preview {
    let locationView = SimpleForm(sections: [
        SimpleFormSection(
            "Location",
            rows: [
                SimpleLabeledRow(label: "Number", detail: "\(555)"),
                SimpleLabeledRow(label: "Street", detail: "Nowhere St"),
                SimpleLabeledRow(label: "Suburb", detail: "Antartica"),
                SimpleLabeledRow(label: "Postcode", detail: "\(123456)"),
            ]
        ),
    ])

    return NavigationStack {
        SimpleForm(sections: [
            SimpleFormSection(
                "Personal Details",
                rows: [
                    SimpleLabeledRow(label: "First", detail: "Joe"),
                    SimpleLabeledRow(label: "Last", detail: "Smith"),
                    SimpleDestinationRow(label: "Location", detail: "Antarctica", destination: locationView),
                ]
            ),
            SimpleFormSection(
                "MetaData ",
                rows: [
                    SimpleDestinationRow(label: "Identification", destination: Text("Some Destination Detail")),
                ]
            ),
        ])
    }
}
