//
//  ModularContainerView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct ModularContainerView<StoredType: Codable, ProjectedPropertyType: BidirectionalCollection>: View where StoredType: ModularStoreResourcePreferenceProvider {
    @ObservedObject var store: ModularStore<StoredType, ProjectedPropertyType>
    
    let contentTitle: String
    let projectedView: (_ projectedValue: ProjectedPropertyType) -> AnyView
    
    @State private var jsonExistsInDocuments: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                DownloadStateSymbolView(state: store.downloadState, autoHideDelay: 1)
                
                projectedView(store.projectedIterable)
                    .navigationTitle(contentTitle)
                    .navigationBarTitleDisplayMode(.inline)

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
    }
    
    // MARK: - View Specific Utility Functions

    func updateJSONExistsInDocuments() {
        jsonExistsInDocuments = Constants.Directory.userDocuments.fileExists(StoredType.jsonFile)
    }
    
    /// attempt to load json for source urls
    func loadEntries() {
        // only need to load if store.projected is empty array
        guard store.projectedIterable.isEmpty else { return }
        QuickLog.ui.info("Projected content empty.  Will attempt to load from search directories.")
        // start searching sources
        Task {
            do {
                try await store.downloadJSON()
            } catch {
                // unable to find and decode the JSON file
                // from any of the source URLs
                QuickLog.ui.error("Unable to load \(contentTitle)!!")
                showLoadErrorAlert()
            }
        }
    }
    
    // MARK: - Preparation of Reusable Alert

    @MainActor func showLoadErrorAlert() {
        alertTitle = "Something Went Wrong 😥"
        alertMessage = "Unable to load the \(contentTitle) from expected locations."
        showAlert = true
    }
    
}

#Preview {
    ModularContainerView(
        store: ModularStore(
            initialCodable: APIEntries.empty,
            projectedKeyPath: \APIEntries.entries
        ),
        contentTitle: Constants.APIModule.title
    ) { apis in
        AnyView(APIEntriesView(apis: apis))
    }
}
