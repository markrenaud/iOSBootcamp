//
//  ColorModel.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

/// A model that represents an RGB color.
struct ColorModel {
    /// The range of values allowed for each component.
    static let allowedColorRange: ClosedRange<Int> = 0...255
    
    /// The `red` component value.
    /// The value will be clamped between  0 and 255.
    @Clamped(ColorModel.allowedColorRange) var red: Int = ColorModel.allowedColorRange.lowerBound
    /// The `green` component value.
    /// The value will be clamped between  0 and 255.
    @Clamped(ColorModel.allowedColorRange) var green: Int = ColorModel.allowedColorRange.lowerBound
    /// The `blue` component value.
    /// The value will be clamped between  0 and 255.
    @Clamped(ColorModel.allowedColorRange) var blue: Int = ColorModel.allowedColorRange.lowerBound

    /// The SwiftUI `Color` that is represented by the red, green, and blue component values.
    ///
    /// - Note: maps each of the red, green and blue compoents to a Double between 0.0 and 1.0
    /// from a value in the allowedColorRange (essentially normalizing the value over the range).
    var color: Color {
        return Color(
            red: normalize(red, in: ColorModel.allowedColorRange),
            green: normalize(green, in: ColorModel.allowedColorRange),
            blue: normalize(blue, in: ColorModel.allowedColorRange)
        )
    }
    
    /// Maps a value contained within a given range to a Double value between 0.0 and 1.0
    private func normalize(_ value: Int, in range: ClosedRange<Int>) -> Double {
        let doubleRange = Double(range.upperBound - range.lowerBound)
        return (Double(value - range.lowerBound) / doubleRange)
    }
}

extension ColorModel {
    static let pantoneOrange = ColorModel(red: 255, green: 108, blue: 47)
}
