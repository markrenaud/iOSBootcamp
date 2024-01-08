//
//  APIEntries.swift
//  Created by Mark Renaud (2023).
//

import Foundation

struct APIEntries: Codable, Hashable {
    var count: Int { entries.count }
    let entries: [APIEntry]
    
    init(entries: [APIEntry]) {
        self.entries = entries
    }
    
    // Implement manual encode / decode
    // to handle computed count property
    // when writing out to JSON
    enum CodingKeys: CodingKey {
        case count
        case entries
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.entries = try container.decode([APIEntry].self, forKey: .entries)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.entries, forKey: .entries)
        try container.encode(self.count, forKey: .count)
    }
    
}

extension APIEntries {
    static let empty = APIEntries(entries: [])
}
