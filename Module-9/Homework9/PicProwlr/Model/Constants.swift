//
//  Constants.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

enum Constants {
    
    struct KeyName {
        static let apiToken = "PEXELS_API_KEY"
    }
    
    struct Animation {
        /// The maximum angle of rotation of eyebrows either way in degrees.
        static let maxEyebrowRotation: Double = 3.0
    }
    
    struct Styling {
        static let shadowRadius: CGFloat = 5.0
        static let shadowColor: Color = .white
        
        static let cornerRadiusSmall: CGFloat = 5.0
        static let cornerRadiusLarge: CGFloat = 25.0
        
        static let gridItemSpacing: CGFloat = 20.0
        static let gridItemMinWidth: CGFloat = 150.0
        static let gridItemMaxWidth: CGFloat = 300.0
        
        static let overlayPadding: CGFloat = 5.0
    }
    
    struct External {
        static let pexels: URL = URL(string: "https://www.pexels.com")!
        static let pexelsAPIBase = URL(string: "https://api.pexels.com/v1")!
    }
    
    struct Background {
        static let overlay = Material.thin
    }
    
    struct Fonts {
        static let handwritingLarge: Font = .custom("DeliciousHandrawn-Regular", fixedSize: 30)
        static let handwritingSmall: Font = .custom("DeliciousHandrawn-Regular", fixedSize: 20)
        static let generalFont: Font = .custom("AvenirNext-Regular", size: 20, relativeTo: .title3)
        static let overlayFont: Font = .system(.caption, design: .default, weight: .bold)
    }
    
    enum Symbols: String {
        case settings = "gearshape.fill"
        case export = "square.and.arrow.up"
        
        /// Returns the raw value of the symbol which is the system name for the icon.
        var name: String {
            rawValue
        }
    }
    
}
