//
//  PexelsResponse.swift
//  Created by Mark Renaud (2024).
//

import Foundation

struct PexelsPhotoResponse: Codable {
    /// The total number of results for the request.
    let totalResults: Int
    /// The current page number.
    let page: Int
    // The number of results returned with each page.
    let perPage: Int
    /// An array of `PexelsPhoto`s.
    let photos: [PexelsPhoto]
    /// URL for the next page of results, if applicable.
    let nextPage: URL?
    /// URL for the previous page of results, if applicable.
    let previousPage: URL?

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case page
        case perPage = "per_page"
        case photos
        case nextPage = "next_page"
        case previousPage = "prev_page"
    }
}

extension PexelsPhotoResponse {
    
    /// The page number for the next page of results, if applicable.
    var nextPageNumber: Int? {
        // if a next page url exists, we can calculate the next page number
        // directly from the current page number + 1
        
        guard nextPage.notNil else { return nil }
        return page + 1
    }
    
}
