//
//  Constants.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

enum Constants {
    enum Typography {
        static let title = Font.system(.largeTitle, weight: .bold)
        static let label = Font.system(.body)
        static let boldLabel = Font.system(.body, weight: .bold)
    }
    
    enum Styling {
        static let cornerRadius: CGFloat = 20.0
        static let borderWidth: CGFloat = 3.0
        static let buttonPadding: CGFloat = 20.0
        
        static let pickerBorderWidth: CGFloat = 20.0
    }
}
