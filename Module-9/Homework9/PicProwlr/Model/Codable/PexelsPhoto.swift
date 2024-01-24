//
//  PexelsPhoto.swift
//  Created by Mark Renaud (2024).
//

import Foundation

// Example JSON from Pexels API
/*
 {
   "id": 2014422,
   "width": 3024,
   "height": 3024,
   "url": "https://www.pexels.com/photo/brown-rocks-during-golden-hour-2014422/",
   "photographer": "Joey Farina",
   "photographer_url": "https://www.pexels.com/@joey",
   "photographer_id": 680589,
   "avg_color": "#978E82",
   "src": {
     "original": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg",
     "large2x": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
     "large": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
     "medium": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=350",
     "small": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=130",
     "portrait": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
     "landscape": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
     "tiny": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
   },
   "liked": false,
   "alt": "Brown Rocks During Golden Hour"
 }
 */

/// A Pexels Photo Resource
///
/// API Reference: https://www.pexels.com/api/documentation/#photos-overview
struct PexelsPhoto: Codable, Identifiable {
    /// The id of the photo.
    let id: Int
    /// The real width of the photo in pixels.
    let width: Int
    /// The real height of the photo in pixels.
    let height: Int
    /// The Pexels URL where the photo is located.
    let url: URL
    /// The name of the photographer who took the photo.
    let photographer: String
    /// The URL of the photographer's Pexels profile.
    let photographerURL: URL
    /// The id of the photographer.
    let photographerID: Int
    /// The average color of the photo. Useful for a placeholder while the image loads.
    let avgColor: String
    /// An assortment of different image sizes that can be used to display this Photo.
    let src: PexelsPhotoSource
    /// If the API user has liked the Photo on Pexels.
    let liked: Bool
    /// Text description of the photo for use in the alt attribute.
    let alt: String

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case url
        case photographer
        case src
        case liked
        case alt
        case photographerURL = "photographer_url"
        case photographerID = "photographer_id"
        case avgColor = "avg_color"
    }
}

extension PexelsPhoto {
    struct PexelsPhotoSource: Codable {
        let original: URL
        let large2x: URL
        let large: URL
        let medium: URL
        let small: URL
        let portrait: URL
        let landscape: URL
        let tiny: URL
    }
}
