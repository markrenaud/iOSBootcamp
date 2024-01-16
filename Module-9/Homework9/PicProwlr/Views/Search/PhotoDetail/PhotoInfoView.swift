//
//  PhotoInfoView.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

/**
 An information view that attempts to meet the Pexel API Guidelines:
 https://www.pexels.com/api/documentation/#guidelines

 "Always credit our photographers when possible (e.g. "Photo by John Doe on Pexels"
 with a link to the photo page on Pexels"
 */
struct PhotoInfoView: View {
    let photo: PexelsPhoto
    
    var body: some View {
        Link("Photo by \(photo.photographer) on Pexels", destination: photo.url)
            .padding(.horizontal)
            .foregroundStyle(.overlayForeground)
            .font(Constants.Fonts.overlayFont)
            .padding(Constants.Styling.overlayPadding)
            .background(Constants.Background.overlay)
            .mask(RoundedRectangle(cornerRadius: Constants.Styling.cornerRadiusLarge))
            .preferredColorScheme(.dark)
    }
}

#Preview {
    ZStack {
        ProwlrGradient()
        PhotoInfoView(photo: .dachshund)
    }
}
