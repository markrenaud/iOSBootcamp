//
//  PexelsPhoto+Color.swift
//  Created by Mark Renaud (2024).
//
    

import SwiftUI

extension PexelsPhoto {
    
    /// The average color of the photo as a SwiftUI Color.
    /// Useful for a placeholder while the image loads.
    /// If the average color fails to convert to a SwiftUI Color, return Color.white
    var avgSwiftUIcolor: Color {
        (try? Color.from(cssHexColor: avgColor)) ?? .white
    }
    
}
