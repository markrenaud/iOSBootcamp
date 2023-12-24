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
    }

    enum Color {
        static let checked = SwiftUI.Color.green
        static let unchecked = SwiftUI.Color.red
    }

    enum Font {
        static let taskItemList: SwiftUI.Font = .headline
        static let toolbarButton: SwiftUI.Font = .headline
    }
}
