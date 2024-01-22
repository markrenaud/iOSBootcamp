//
//  PexelPolaroid.swift
//  Created by Mark Renaud (2024).
//
    

import SwiftUI

/// A view that represents a polaroid-style photo using Pexels images.
struct PexelsPolaroid: View {
    
    let photo: PexelsPhoto
    let size: PexelsPhotoSize
    
    var body: some View {
        PolaroidView(
            frameStyle: Color.polaroidFrame,
            photoBackgroundColor: photo.avgSwiftUIcolor
        ) {
                // `AsyncImage` is used to load and display an image from a
                // URL asynchronously.
                // The average background colour information in the PexelsPhoto
                // is used for the placeholder.
                AsyncImage(
                    url: photo.url(for: size)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .foregroundStyle(photo.avgSwiftUIcolor)
                    }
            } annotation: {
                VStack {
                    HStack {
                        Spacer()
                        Text("#\(photo.id)")
                            .font(Constants.Fonts.handwritingLarge)
                    }
                    Spacer()
                }
            }
            .shadow(
                color: Constants.Styling.shadowColor,
                radius: Constants.Styling.shadowRadius
            )
            .padding(Constants.Styling.shadowRadius)
    }
}

#Preview {
    ZStack {
        ProwlrGradient()
        VStack {
            PexelsPolaroid(photo: .dachshund, size: .medium)
                .frame(width: 150)
            PexelsPolaroid(photo: .dachshund, size: .medium)
        }
    }
}
