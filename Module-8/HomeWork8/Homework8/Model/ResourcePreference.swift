//
//  Constants.swift
//  Created by Mark Renaud (2024).
//

import Foundation

struct ResourcePreference: Codable {

    enum Location: String, Codable {
        case remoteServer
        case cachedDocument
        case appBundle
    }
    
    let location: Location
    var enabled: Bool
    
    var title: String { location.rawValue }
}

extension ResourcePreference: Identifiable {
    var id: String { location.rawValue }
}

extension ResourcePreference: CustomStringConvertible {
    var description: String {
        "[\(enabled ? "ON" : "OFF")] \(location.rawValue)"
    }
}

extension [ResourcePreference] {
    func jsonData() -> Data {
        try! JSONEncoder().encode(self)
    }
    
    static func from(json: Data) -> [ResourcePreference]? {
        return try? JSONDecoder().decode([ResourcePreference].self, from: json)
    }
    
    static let defaults: [ResourcePreference] = [
        ResourcePreference(location: .remoteServer, enabled: true),
        ResourcePreference(location: .cachedDocument, enabled: true),
        ResourcePreference(location: .appBundle, enabled: true)
    ]
}

