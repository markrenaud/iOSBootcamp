//
//  CGImage+Data.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

enum ImageLoadingError: Error {
    case invalidData
}

// extension to allow loading a CGImage from data
// useful for SwiftUI - Image can load from CGImage on both mac and iOS.
extension CGImage {
    static func load(from data: Data) throws -> CGImage {
        guard
            let source = CGImageSourceCreateWithData(data as CFData, nil),
            let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            throw ImageLoadingError.invalidData
        }
        return cgImage
    }
}
