//
//  PexelsPhotoSize.swift
//  Created by Mark Renaud (2024).
//
    
import SwiftUI

enum PexelsPhotoSize {
    case original
    case large2X
    case large
    case medium
    case small
    case portrait
    case landscape
    case tiny
    
    /// Returns the URL for the specified photo size.
    func url(for photo: PexelsPhoto) -> URL {
        switch self {
        case .original:
            return photo.src.original
        case .large2X:
            return photo.src.large2x
        case .large:
            return photo.src.large
        case .medium:
            return photo.src.medium
        case .small:
            return photo.src.small
        case .portrait:
            return photo.src.portrait
        case .landscape:
            return photo.src.landscape
        case .tiny:
            return photo.src.tiny
        }
    }
    
    /// Calculates the expected dimensions for the specified photo size.
    func size(for photo: PexelsPhoto) -> CGSize {
        // Original photo size is determined by the width and height properties
        // of PexelsPhoto data.
        // Other photo sizes are documented in the Pexels API documents:
        // https://www.pexels.com/api/documentation/#photos-overview__response__src
        switch self {
        /// actual photo size
        case .original:
            return CGSize(width: photo.width, height: photo.height)
            
        /// W 940px X H 650px DPR 2
        case .large2X:
            return CGSize(width: 940.0 * 2.0, height: 650.0 * 2.0)
            
        /// W 940px X H 650px DPR 1
        case .large:
            return CGSize(width: 940.0, height: 650.0)
        
        /// The image scaled proportionally so that it's new height is 350px
        case .medium:
            // Ensure that the image is scaled proportionally.
            return CGSize(width: photo.width, height: photo.height)
                .scaledToHeight(pixelHeight: 350)
            
        /// The image scaled proportionally so that it's new height is 130px
        case .small:
            // Ensure that the image is scaled proportionally.
            return CGSize(width: photo.width, height: photo.height)
                .scaledToHeight(pixelHeight: 130)
        
        /// The image cropped to W 800px X H 1200px
        case .portrait:
            return CGSize(width: 800, height: 1200)
                
        /// The image cropped to W 1200px X H 627px
        case .landscape:
            return CGSize(width: 1200, height: 627)
        
        /// The image cropped to W 280px X H 200px
        case .tiny:
            return CGSize(width: 280, height: 200)
        }
    }
}

private extension CGSize {
    /// Scales the CGSize proportionally to match the given pixel height.
    /// - Note: as dealing with pixels, partial units are rounded down (cannot have "part of a pixel"!)
    func scaledToHeight(pixelHeight: Int) -> CGSize {
        let aspectRatio = self.width / self.height
        let scaledWidth = floor(aspectRatio * Double(pixelHeight))
        return CGSize(width: scaledWidth, height: Double(pixelHeight))
    }
}
