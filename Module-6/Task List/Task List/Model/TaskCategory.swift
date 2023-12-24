//
//  TaskCategory.swift
//  Created by Mark Renaud (2023).
//

import Foundation

enum TaskCategory: String, CaseIterable, Identifiable, Hashable {
    case personal
    case work
    case home
    case uncategorized

    /// Customized title for UI purposes.
    var title: String {
        switch self {
        case .uncategorized:
            return "No Category"
        default:
            return rawValue.capitalized
        }
    }

    var id: String { rawValue }
}
