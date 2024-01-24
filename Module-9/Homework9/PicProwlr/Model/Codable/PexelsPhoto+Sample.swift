//
//  PexelsPhoto+Sample.swift
//  Created by Mark Renaud (2024).
//
import Foundation

extension PexelsPhoto {
    static let dachshund = PexelsPhoto(
        id: 169524,
        width: 5616,
        height: 3744,
        url: URL(string: "https://www.pexels.com/photo/black-and-tan-long-coat-dog-169524/")!,
        photographer: "Binyamin Mellish",
        photographerURL: URL(string: "https://www.pexels.com/@binyaminmellish")!,
        photographerID: 1570,
        avgColor: "#234F50",
        src: PexelsPhotoSource(
            original: Bundle.main.url(forResource: "pexels-photo-169524-original", withExtension: "jpeg")!,
            large2x: Bundle.main.url(forResource: "pexels-photo-169524-large2x", withExtension: "jpeg")!,
            large: Bundle.main.url(forResource: "pexels-photo-169524-large", withExtension: "jpeg")!,
            medium: Bundle.main.url(forResource: "pexels-photo-169524-medium", withExtension:"jpeg")!,
            small: Bundle.main.url(forResource: "pexels-photo-169524-small", withExtension: "jpeg")!,
            portrait: Bundle.main.url(forResource: "pexels-photo-169524-portrait", withExtension: "jpeg")!,
            landscape: Bundle.main.url(forResource: "pexels-photo-169524-landscape", withExtension: "jpeg")!,
            tiny: Bundle.main.url(forResource: "pexels-photo-169524-tiny", withExtension: "jpeg")!
        ),
        liked: false,
        alt: "Black and Tan Long Coat Dog"
    )
    
}

