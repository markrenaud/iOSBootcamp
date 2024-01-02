//
//  Constants.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

enum Constants {
    enum Symbol {
        static let checked = "checkmark.square"
        static let unchecked = "square"
        static let addItem = "plus.circle.fill"
        static let tag = "tag"
        static let tasksTab = "list.bullet.circle"
        static let completedTab = "checkmark.circle"
        static let categoriesTab = "tag.circle"
    }

    enum Color {
        static let checked = SwiftUI.Color.green
        static let unchecked = SwiftUI.Color.red
        static let gridBackground = SwiftUI.Color.red
        static let gridHighlightBackground = SwiftUI.Color.accentColor
        static let gridText = SwiftUI.Color.white
    }

    enum Font {
        static let taskItemList: SwiftUI.Font = .headline
        static let toolbarButton: SwiftUI.Font = .headline
        static let gridTitle: SwiftUI.Font = .title2.bold()
        static let gridCount: SwiftUI.Font = .title.bold()
    }
}
