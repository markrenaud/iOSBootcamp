//
//  Color+HexString.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

enum ColorError: Error {
    case invalidHexString(_ hexString: String)
}

extension Color {
    /// Valid uppercased hexadecimal characters as a `String`.
    fileprivate static let hexadecimals = "0123456789ABCDEF"
    /// Non hexadecimal characters that will be accepted in a hex color `String`.
    fileprivate static let acceptableNonHex = "# "
    
    /// Removes acceptable non-hexadecimal characters from the input hexadecimal string
    /// and returns the result uppercased.  Throws in invalid characters are found.
    ///
    /// - eg. `#ff ff ff` -> `FFFFFF`
    fileprivate static func parse(hexString: String) throws -> String {
        return try String(hexString
            .uppercased()
            .compactMap {
                if hexadecimals.contains($0) { return $0 }
                if acceptableNonHex.contains($0) { return nil }
                throw ColorError.invalidHexString(hexString)
            }
        )
    }

    /// Converts a hex string to a Color object.
    /// If the conversion fails, an error is thrown.
    static func from(cssHexColor: String) throws -> Color {
        // parse the hexString to just get contiguous uppercased hexadecimal
        // characters - or throw if invalid input.
        var hex = try parse(hexString: cssHexColor)
        
        // CSS Hexadecimal Color Notation
        // Well formatted ref: https://developer.mozilla.org/en-US/docs/Web/CSS/hex-color
        // Canonical ref: https://www.w3.org/TR/css-color-4/#hex-notation
        // valid hex color sequences:
        // #RGB         The three-value syntax
        // #RGBA        The four-value syntax
        // #RRGGBB      The six-value syntax
        // #RRGGBBAA    The eight-value syntax
        
        // Handle different lengths of hexadecimal color strings.
        switch hex.count {
        // adjust shortform 3 and 4 hex color to longform
        case 3, 4:
            // Convert short-form (3 or 4 characters) to long-form by repeating each character.
            // RGB -> RRGGBB
            // RGBA -> RRGGBBAA
            hex = hex.map { "\($0)\($0)" }.joined()
        case 6, 8:
            // Long-form hexadecimal color strings are already in the correct format.
            break
        default:
            // If the string length is not valid, throw an error.
            throw ColorError.invalidHexString(cssHexColor)
        }
                
        // Extract the RGBA values from the hexadecimal string.
        let start = hex.startIndex
        let rRange = start..<hex.index(start, offsetBy: 2)
        let gRange = hex.index(start, offsetBy: 2)..<hex.index(start, offsetBy: 4)
        let bRange = hex.index(start, offsetBy: 4)..<hex.index(start, offsetBy: 6)
        let aRange = hex.count == 8 ? (hex.index(start, offsetBy: 6)..<hex.index(start, offsetBy: 8)) : nil
        
        // Hex values should represent red, green, and blue in UInt8 format (0-255).
        guard
            let red = UInt8(hex[rRange], radix: 16),
            let green = UInt8(hex[gRange], radix: 16),
            let blue = UInt8(hex[bRange], radix: 16),
            // Assume 6-digit hex strings are fully opaque.
            let alpha = aRange != nil ? UInt8(hex[aRange!], radix: 16) : 255
        else {
            // This should not be reached with the previous validations in place.
            throw ColorError.invalidHexString(cssHexColor)
        }
        
        return Color(
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: Double(alpha) / 255.0
        )
    }
}
