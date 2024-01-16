//
//  SearchView.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

struct SearchView: View {
    @Environment(SearchStore.self) private var store: SearchStore
    
    @State private var searchQuery: String = ""
    @State private var isSearchPresented: Bool = false
    
    private let service = PexelsService()
    
    var body: some View {
        VStack {
            if !store.photos.isEmpty {
                VStack {
                    ScrollView(.vertical) {
                        PhotoGrid(photos: store.photos)
                            .padding(.horizontal)
                        if store.nextPageNumber != nil {
                            Button("Show More Results") { loadNextPage() }
                                .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }
                
            searchMessage
                .frame(maxHeight: 200.0)
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background { ProwlrGradient() }
        .searchable(text: $searchQuery, isPresented: $isSearchPresented, placement: .automatic, prompt: "search query ...")
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .onSubmit(of: .search) { searchPhotos() }
        .navigationTitle(store.requestedSearchQuery)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Settings", systemImage: Constants.Symbols.settings.name)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Link("Photos provided by Pexels", destination: Constants.External.pexels)
                        .foregroundStyle(.overlayForeground)
                        .font(Constants.Fonts.overlayFont)
                        .padding(Constants.Styling.overlayPadding)
                        .background(Constants.Background.overlay)
                        .mask(RoundedRectangle(cornerRadius: Constants.Styling.cornerRadiusLarge))
                    Spacer()
                }
                .preferredColorScheme(.dark)
            }
        }
        .toolbar(.visible, for: .bottomBar, .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .bottomBar, .navigationBar)
    }
    
    @ViewBuilder
    var searchMessage: some View {
        switch store.state {
        case .pending:
            SearchMessage("search to prOWL photos", icon: .upright)
        case .completedWithPhotos:
            // Photos in the store are always shown,
            // hence an empty view is returned here.
            EmptyView()
        case .completedNoPhotos:
            SearchMessage("'\(store.requestedSearchQuery)' - no photos found", icon: .upsideDown)
        case .requested:
            SearchMessage("searching ...", icon: .upright, animated: true)
        case .failed(let failMessage):
            SearchMessage(failMessage, icon: .upsideDown)
        }
    }
    
    func searchPhotos() {
        let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        // Clear the search query after initiating a search.
        searchQuery = ""
        // Dismiss the search presentation after initiating a search
        isSearchPresented = false
        Task { await store.newSearch(query: trimmedQuery) }
    }
    
    func loadNextPage() {
        Task { await store.retrieveNext() }
    }
}

#Preview("Results") {
    NavigationStack {
        SearchView()
    }
    .environment(
        SearchStore(
            photos: [.dachshund],
            searchQuery: "dachshund",
            nextPageNumber: 2,
            initialSearchState: .completedWithPhotos
        )
    )
}

#Preview("NoResults") {
    NavigationStack {
        SearchView()
    }
    .environment(
        SearchStore(
            photos: [],
            searchQuery: "dachshund",
            nextPageNumber: nil,
            initialSearchState: .completedNoPhotos
        )
    )
}

#Preview("Failed") {
    NavigationStack {
        SearchView()
    }
    .environment(
        SearchStore(
            photos: [],
            searchQuery: "dachshund",
            nextPageNumber: nil,
            initialSearchState: .failed(message: "API Error!")
        )
    )
}

#Preview("Requested") {
    NavigationStack {
        SearchView()
    }
    .environment(
        SearchStore(
            photos: [],
            searchQuery: "dachshund",
            nextPageNumber: nil,
            initialSearchState: .requested
        )
    )
}

#Preview("Pending") {
    NavigationStack {
        SearchView()
    }
    .environment(
        SearchStore()
    )
}
