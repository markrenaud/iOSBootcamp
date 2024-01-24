//
//  SearchStore.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

@Observable
class SearchStore {
    enum UpdateMode {
        case add
        case replace
    }
    
    enum SearchState {
        /// A search has not been executed
        case pending
        /// A search has been requested, but not completed
        case requested
        /// A search was executed and photos were found and added to the store.
        case completedWithPhotos
        /// A search was executed, but the term returned an empty result.
        case completedNoPhotos
        /// A search was executed, but failed
        case failed(message: String)
    }
    
    private(set) var photos: [PexelsPhoto]
    /// The number of the next page yet to be retrieved in the search (if available).
    ///
    /// If we are up to page 5 in the search, and:
    ///  - a page 6 is available, `nextPageNumber` will be 6.
    ///  - no page 6 exists, `nextPageNumber` will be nil.
    private(set) var nextPageNumber: Int?
    
    private let pexelsService: PexelsService
    
    /// A flag that returns `true` if the `PexelsService` has an empty token string.
    /// The PexelsService looks in UserDefaults and Environment Values for the token.
    /// This flag is used to determine if the app needs to display the settings screen
    /// on startup.
    var emptyToken: Bool {
        pexelsService.emptyToken
    }
    
    /// The last search term that was requested from the pexels service
    private(set) var requestedSearchQuery: String
    
    private(set) var state: SearchState
    
    init(photos: [PexelsPhoto] = [], searchQuery: String = "", nextPageNumber: Int? = nil, initialSearchState: SearchState = .pending) {
        self.photos = photos
        self.requestedSearchQuery = searchQuery
        self.nextPageNumber = nextPageNumber
        self.pexelsService = PexelsService()
        self.state = initialSearchState
    }
    
    /// All updates to photos and nextPageURL should be performed
    /// through this call (enforces MainActor for UI).
    @MainActor private func updateStore(mode: UpdateMode, photos: [PexelsPhoto], nextPageNumber: Int? = nil) {
        self.nextPageNumber = nextPageNumber
        switch mode {
        case .add:
            self.photos.append(contentsOf: photos)
        case .replace:
            self.photos = photos
        }
    }
    
    /// All updates to to search state should be performed through this call (enforces MainActor for UI)
    @MainActor private func updateStore(state newState: SearchState) {
        withAnimation(.snappy) {
            self.state = newState
        }
    }
    
    /// Performs a new search with the given query on Pexels, and updates the store with the initial results received.
    /// - Parameter query: The search term to use for the new search.
    func newSearch(query: String) async {
        // store ther requested term - as may be needed
        // to retrieve further pages
        requestedSearchQuery = query.trimmingCharacters(in: .whitespaces)
        
        do {
            // empty the existing store
            await updateStore(
                mode: .replace,
                photos: [],
                nextPageNumber: nil
            )
            
            // set search state for UI
            await updateStore(state: .requested)
            
            // run Pexels service
            let pexelsResult = try await pexelsService.search(
                term: requestedSearchQuery
            )
            
            // update store with new results
            await updateStore(
                mode: .replace,
                photos: pexelsResult.photos,
                nextPageNumber: pexelsResult.nextPageNumber
            )
            
            // completed search - update search state
            await processCompletedSearch()
        } catch {
            print("search error", error)
            // process the error
            // the error will also update the search state
            await process(searchError: error)
        }
    }
    
    /// Requests the next page of results from Pexels and appends them to the current store.
    func retrieveNext() async {
        do {
            // ensure that there is a next page to retrieve
            guard let nextPageNumber else { return }
            
            // set search state for UI
            await updateStore(state: .requested)
            
            // run Pexels service
            let nextPexelsResult = try await pexelsService.search(
                term: requestedSearchQuery,
                pageNumber: nextPageNumber
            )
            
            // update store with new results
            await updateStore(
                mode: .add,
                photos: nextPexelsResult.photos,
                nextPageNumber: nextPexelsResult.nextPageNumber
            )
            
            // completed search - update search state
            await processCompletedSearch()
        } catch {
            // process the error
            // the error will also update the search state
            await process(searchError: error)
        }
    }
    
    /// Manages the store's response to a successful response from PexelsService.
    private func processCompletedSearch() async {
        if photos.isEmpty {
            await updateStore(state: .completedNoPhotos)
        } else {
            await updateStore(state: .completedWithPhotos)
        }
    }
    
    /// Manages the store's response to an error from the PexelsService.
    private func process(searchError: Error) async {
        guard let pexelsError = searchError as? PexelsError else {
            // some other error occured - handle with generic response
            await updateStore(state: .failed(message: "Error retrieving photos!"))
            return
        }
        
        switch pexelsError {
        case .httpResponse(let code):
            await updateStore(state: .failed(message: "Pexels API Error\nResponse Code: \(code)"))
        default:
            await updateStore(state: .failed(message: "Pexels API Error\nThere was an error accessing the Pexels API"))
        }
    }
}
