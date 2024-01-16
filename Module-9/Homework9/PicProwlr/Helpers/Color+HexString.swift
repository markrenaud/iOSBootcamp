//
//  Color+HexString.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

extension Color {
    /// Converts a hex string to a Color.
    /// If the conversion fails, defaults to provided Color (or white if no default is provided).
    static func from(hexString: String?, defaultingTo failover: Color = .white) -> Color {
        // Filter the uppercased hex string and remove any non-hexadecimal characters.
        // Expect a 6-digit hex color value - return failover color if the format is incorrect.
        guard
            let filteredHexString = hexString?.uppercased().filter({ "0123456789ABCDEF".contains($0) }),
            filteredHexString.count == 6
        else {
            return failover
        }

        let start = filteredHexString.startIndex
        let rRange = start..<filteredHexString.index(start, offsetBy: 2)
        let gRange = filteredHexString.index(start, offsetBy: 2)..<filteredHexString.index(start, offsetBy: 4)
        let bRange = filteredHexString.index(start, offsetBy: 4)..<filteredHexString.index(start, offsetBy: 6)

        // Hex values should represent red, green, and blue in UInt8 format (0-255).
        guard
            let red = UInt8(filteredHexString[rRange], radix: 16),
            let green = UInt8(filteredHexString[gRange], radix: 16),
            let blue = UInt8(filteredHexString[bRange], radix: 16)
        else {
            return failover
        }

        return Color(
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0
        )
    }
}
