//
//  AsyncPhotoDetailView.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

struct AsyncPhotoDetailView: View {
    let photo: PexelsPhoto
    private let avgColor: Color
    private let downloadURL: URL

    init(photo: PexelsPhoto, downloadSize: PexelsPhotoSize) {
        self.photo = photo
        self.avgColor = Color.from(hexString: photo.avgColor)
        self.downloadURL = photo.url(for: downloadSize)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Gradient(colors: [avgColor, .prowlrViolet, avgColor]))
                .ignoresSafeArea()
            ProgressAsyncImage(url: downloadURL) { progress in
                // `AnimatedProgressOwl` is a custom view that
                // represents the loading progress.
                // It is a fancy progress bar themed for PrOWLr.
                AnimatedProgressOwl(progress: progress)
                    .padding(20)
            } imageContent: { image in
//                // `ZoomView` is a custom view that allows
//                // the downloaded the image to be zoomed.
//                ZoomView {
//                    image
//                }
//
                // Replaced above ZoomView (glitchy native SwiftUI) with a
                // more robust ZoomableView (which is a SwiftUi wrapper
                // around a UIScrollView).
                // The ZoomableView allows the downloaded image to be
                // zoomed with pinch gesture, and scaled to full size or
                // size that fits with a double tap.
                ZoomableView(content: image)
                
            }
            VStack {
                Spacer()
                HStack {
                    PhotoInfoView(photo: photo)
                        .padding(.horizontal)
                    Spacer()
                }
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        AsyncPhotoDetailView(photo: .dachshund, downloadSize: .large2X)
    }
}
