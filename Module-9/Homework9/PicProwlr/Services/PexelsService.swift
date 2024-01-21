//
//  PexelsService.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

enum PexelsError: Error {
    /// Unable to find `PEXELS_API_KEY` environment variable.
    case missingAPIToken
    /// Unexpected HTTP Response
    case httpResponse(code: Int)
}

class PexelsService {
    enum HTTPMethod: String {
        case get = "GET"
    }
    
    /// private let token: String?
    private let baseURL = Constants.External.pexelsAPIBase
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        //        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: config)
    }()
    
    private let decoder: JSONDecoder = JSONDecoder()
    
    /// Returns true if there is a token string.
    var emptyToken: Bool {
        if let token {
            return token.isEmpty
        }
        return true
    }
    
    /// The API token for the Pexel Service.
    /// Will check in `UserDefaults` for a token,
    /// If not found, will check Environment Variables
    /// If still not found, will return nil.
    private var token: String? {
        // check for a key in UserDefaults - and ensure the key is not empty
        if
            let userDefaultsAPIKey = UserDefaults.standard.string(forKey: Constants.KeyName.apiToken),
            !userDefaultsAPIKey.isEmpty
        {
            QuickLog.service.info("Using API Key from User Defaults")
            return userDefaultsAPIKey
            // check for a key in UserDefaults - and ensure the kis is not empty
        } else if
            let environmentAPIKey = ProcessInfo.processInfo.environment[Constants.KeyName.apiToken],
            !environmentAPIKey.isEmpty
        {
            QuickLog.service.info("Using API Key from Environment Values.")
            return environmentAPIKey
        } else {
            QuickLog.service.error("No API Key found!")
            return nil
        }
    }
    
    /// Sends a GET request to the constructed endpoint with the API Token
    /// in passed in the `Authorization` header.
    private func authorizedGETRequest(
        resource: String,
        queryItems: [URLQueryItem]
    ) async throws -> Data {
        let url = baseURL
            .appending(component: resource)
            .appending(queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        if let token {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await session.data(for: request)
        try checkSuccessfulHTTPResponse(response)
        return data
    }
    
    /// Sends a GET request to the constructed endpoint with the API Token
    /// in passed in the `Authorization` header.
    private func authorizedGETRequest<T: Codable>(
        resource: String,
        queryItems: [URLQueryItem],
        returnType: T.Type
    ) async throws -> T {
        let data = try await authorizedGETRequest(resource: resource, queryItems: queryItems)
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
    
    func search(term: String, pageNumber: Int? = nil) async throws -> PexelsPhotoResponse {
        var queryItems = [
            URLQueryItem(name: "query", value: term),
            // default to returning 20 photos per request
            URLQueryItem(name: "per_page", value: "20"),
        ]
        
        if let pageNumber {
            queryItems.append(URLQueryItem(name: "page", value: "\(pageNumber)"))
        }
        
        return try await authorizedGETRequest(
            resource: "search",
            queryItems: queryItems,
            returnType: PexelsPhotoResponse.self
        )
    }
    
    /// Let's drop back a level from UIImage to underlying data type that is supported both by iOS and macOS
    /// to allow this code to be cross-platform and not rely on UIKit technology.
    func load(size: PexelsPhotoSize, for photo: PexelsPhoto) async throws -> CGImage {
        let (data, response) = try await session.data(from: size.url(for: photo))
        try checkSuccessfulHTTPResponse(response)
        return try CGImage.load(from: data)
    }
    
    /// if the URLResponse was in fact a HTTPURLResponse, checks the status code and throws
    /// if not one of the successful response codes: 200-299.
    /// See https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
    private func checkSuccessfulHTTPResponse(_ response: URLResponse) throws {
        if let response = response as? HTTPURLResponse,
           !(200 ..< 300).contains(response.statusCode)
        {
            QuickLog.service.info("Unexpected HTTP Repsonse Code: \(response.statusCode)")
            throw PexelsError.httpResponse(code: response.statusCode)
        }
    }
}
