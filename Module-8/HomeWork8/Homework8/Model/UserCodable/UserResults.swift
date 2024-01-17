//
//  UserResults.swift
//  Created by Mark Renaud (2023).
//

import Foundation

struct UserResults: Codable {
    let users: [User]
    let info: Info
    
    enum CodingKeys: String, CodingKey {
        case users = "results"
        case info
    }
}

extension UserResults {
    struct Info: Codable {
        let seed: String
        let results: Int
        let page: Int
        let version: String
    }
}

extension UserResults {
    private static let sampleData = try! Data(contentsOf: UserResults.mainBundleURL)
    static let sample = try! JSONDecoder().decode(UserResults.self, from: sampleData)
    static let empty = UserResults(users: [], info: Info(seed: "empty", results: -1, page: -1, version: "-1"))
}

extension UserResults: ModularStoreResourcePreferenceProvider {
    static let jsonFile = "aboveandbeyond.json"
    /// As no remote url was provided for the UserModule, we will use the main bundle json
    /// as a placeholder
    static let remoteEndpointURL = Constants.Directory.mainBundle.url(for: jsonFile)
    static let mainBundleURL = Constants.Directory.mainBundle.url(for: jsonFile)
    static let documentsURL = Constants.Directory.userDocuments.url(for: jsonFile)
}
