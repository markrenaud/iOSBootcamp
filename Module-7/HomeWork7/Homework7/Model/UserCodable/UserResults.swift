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
    private static let sampleData = try! Data(contentsOf: Constants.Directory.mainBundle.url(for: .users))
    static let sample = try! JSONDecoder().decode(UserResults.self, from: sampleData)
    static let empty = UserResults(users: [], info: Info(seed: "empty", results: -1, page: -1, version: "-1"))
}
