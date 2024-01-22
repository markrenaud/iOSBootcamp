//
//  URLRequest+Enums.swift
//  Created by Mark Renaud (2024).
//

import Foundation

extension URLRequest {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
        case options = "OPTIONS"
    }
    
    /// Initialises a `URLRequest` with the specified `HTTPMethod`.
    init(method: HTTPMethod, url: URL) {
        self.init(url: url)
        self.httpMethod = method.rawValue
    }

    enum HTTPHeader: String {
        case authorization = "Authorization"
    }
    
    /// Sets the value for the specified HTTP header field.
    mutating func apply(header: HTTPHeader, value: String) {
        self.setValue(value, forHTTPHeaderField: header.rawValue)
    }
}
