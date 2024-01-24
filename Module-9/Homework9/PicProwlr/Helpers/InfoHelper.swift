//
//  InfoHelper.swift
//  Created by Mark Renaud (2024).
//

import Foundation

struct InfoHelper {
    /// Retrieves the string value from Info.plist for the specified key.
    static func stringValue(forKey key: String) -> String? {
        Bundle.main.infoDictionary?[key] as? String
    }
}
