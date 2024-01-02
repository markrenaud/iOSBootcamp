//
//  APIEntry.swift
//  Created by Mark Renaud (2023).
//

import Foundation

/// Represents a single API entry.
struct APIEntry: Codable {

    let api: String
    let description: String
    let auth: String?
    let https: Bool
    let cors: CORS
    let link: URL
    let category: String
    
    // Custom coding keys to map JSON keys to the
    // property names following Swift's naming conventions.
    enum CodingKeys: String, CodingKey {
        case api = "API"
        case description = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}

extension APIEntry: Hashable, Identifiable {
    // A slightly cheaty way to get an ID for SwiftUI purposes.
    // It is 'ok' to use here, as the properties are immutable
    // (meaning that the hash value won't change over the life
    // of the APIEntry instance).
    // Additionally, hash values can vary between different runs of the
    // application - meaning that this hash-based ID should not be persisted.
    // We are not encoding/decoding the property (it's purely a computed
    // property).
    var id: Int { hashValue }
}

extension APIEntry {
    /// Enum representing the CORS support status of the API.
    ///
    /// To account for missing or unaccounted-for strings (eg. "uknown" rather than "unknown"),
    /// decoded inputs that do not resolve to `.yes` or `.no` will default to `.unknown`.
    enum CORS: String, Codable, CustomStringConvertible {
        case yes
        case no
        case unknown

        init(from decoder: Decoder) throws {
            // Decode the string value from JSON, trim whitespace, 
            // and convert to lowercase. Use "unknown" as the raw value if the
            // string cannot be obtained.
            let rawValue = (
                try? decoder.singleValueContainer()
                    .decode(String.self)
                    .trimmingCharacters(in: .whitespaces)
                    .lowercased()
            ) ?? "unknown"

            // Decode value, defaulting to .unknown for unexpected values.
            self = CORS(rawValue: rawValue) ?? .unknown
        }

        var description: String { rawValue }
    }
}

extension APIEntry {
    static let axolotl = APIEntry(
        api: "Axolotl",
        description: "Collection of axolotl pictures and facts",
        auth: "",
        https: true,
        cors: .no,
        link: URL(string: "https://theaxolotlapi.netlify.app/")!,
        category: "Animals"
    )

    static let circleCI = APIEntry(
        api: "CircleCI",
        description: "Automate the software development process using continuous integration and continuous delivery",
        auth: "apiKey",
        https: true,
        cors: .unknown,
        link: URL(string: "https://circleci.com/docs/api/v1-reference/")!,
        category: "Continuous Integration"
    )
}
