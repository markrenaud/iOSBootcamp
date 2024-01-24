//
//  PexelsPhoto+PexelsPhotoSize.swift
//  Created by Mark Renaud (2024).
//
    
import Foundation

/// Extension to provide convenient access to URLs and expected dimensions
/// for different photo sizes of a PexelsPhoto.
extension PexelsPhoto {
    /// Returns the URL for the specified photo size of this PexelsPhoto.
    func url(for photoSize: PexelsPhotoSize) -> URL {
        photoSize.url(for: self)
    }
    
    /// Returns the expected dimensions for the specified photo size of this PexelsPhoto.
    func expectedDimensions(of photoSize: PexelsPhotoSize) -> CGSize {
        photoSize.size(for: self)
    }
}
