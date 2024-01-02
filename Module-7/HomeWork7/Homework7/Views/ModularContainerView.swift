//
//  ModularContainerView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct ModularContainerView<StoredType: Codable, ProjectedPropertyType: BidirectionalCollection>: View {
    @StateObject var store: ModularStore<StoredType, ProjectedPropertyType>
    let contentTitle: String
    let jsonFile: Constants.JSONFile
    let jsonSearchDirectories: [Constants.Directory]
    let projectedView: (_ projectedValue: ProjectedPropertyType) -> AnyView
    
    @State private var jsonExistsInDocuments: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    /// The expected location of the JSON
    private var documentsJSONURL: URL {
        Constants.Directory.userDocuments.url(for: jsonFile)
    }
    
    var body: some View {
        NavigationStack {
            projectedView(store.projectedIterable)
                .navigationTitle(contentTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { copyJSONButton() }
                .alert(alertTitle, isPresented: $showAlert) {
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text(alertMessage)
                }
                .onAppear {
                    updateJSONExistsInDocuments()
                    loadEntries()
                }
        }
    }
    
    // MARK: - View Specific Utility Functions

    func updateJSONExistsInDocuments() {
        jsonExistsInDocuments = Constants.Directory.userDocuments.fileExists(jsonFile)
    }
    
    /// attempt to load json file from the first available source in the search directories
    func loadEntries() {
        // only need to load if store.projected is empty array
        guard store.projectedIterable.isEmpty else { return }
        
        QuickLog.ui.info("Projected content empty.  Will attempt to load from search directories.")
        
        let searchPaths = jsonSearchDirectories.map { $0.url.appending(path: jsonFile.name) }
        do {
            try store.readJSON(using: searchPaths)
        } catch {
            // unable to find and decode the JSON file of StoredType from
            // any of the search paths.
            QuickLog.ui.error("Unable to load \(jsonFile.name) from search directories")
            showLoadErrorAlert()
        }
    }
    
    // MARK: - Preparation of Reusable Alert

    func showLoadErrorAlert() {
        alertTitle = "Something Went Wrong 😥"
        alertMessage = "Unable to load the \(contentTitle) from expected locations."
        showAlert = true
    }
    
    func showCopyCompletionAlert() {
        alertTitle = "Copied"
        alertMessage = "Successfully copied \(contentTitle) to the Documents directory."
        showAlert = true
    }
    
    func showCopyErrorAlert() {
        alertTitle = "Something Went Wrong 😥"
        alertMessage = "There was an error copying \(contentTitle) to the Documents directory!"
        showAlert = true
    }
        
    func copyJSONButton() -> some View {
        return Button(role: .none) {
            do {
                try store.writeJSON(
                    to: documentsJSONURL,
                    pretty: true
                )
                updateJSONExistsInDocuments()
                showCopyCompletionAlert()
            } catch {
                showCopyErrorAlert()
            }
        } label: {
            Label("Copy to Documents", systemImage: "doc.on.doc")
        }
        .disabled(jsonExistsInDocuments)
    }
}

#Preview {
    ModularContainerView(
        store: ModularStore(
            initialCodable: APIEntries.empty,
            projectedKeyPath: \APIEntries.entries
        ),
        contentTitle: "APIs",
        jsonFile: .apis,
        jsonSearchDirectories: [.mainBundle, .userDocuments]
    ) { apis in
        AnyView(APIEntriesView(apis: apis))
    }
}
