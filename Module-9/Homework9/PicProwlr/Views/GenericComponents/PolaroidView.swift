//
//  PolaroidView.swift
//  Created by Mark Renaud (2024).
//


import SwiftUI

// Constants to help calculate the relative dimensions of a polaroid photo
//
// https://support.polaroid.com/hc/en-us/articles/115012363647-What-are-Polaroid-photo-dimensions-
// polaroids frames are 88mm wide x 107 mm high
// the actual image is 79mm wide x 79mm high
fileprivate struct Polaroid {
    /// the height of the polaroid frame in mm
    private static let frameWidth: Double = 88.0
    /// the width of the polaroid frame in mm
    private static let frameHeight: Double = 107.0
    /// the width of the photo in mm
    private static let photoWidth: Double = 79.0
    /// the height of the photo in mm
    private static let photoHeight: Double = 79.0

    /// the offset of the photo from the frame (both top, left, and right)
    private static let photoOffset: Double = (frameWidth - photoWidth) / 2.0
    /// The aspect ratio of the outer frame of the polaroid
    static let frameAspectRatio: Double = frameWidth / frameHeight
    /// The ratio of the photos width to the frames width
    static let photoPolaroidWidthRatio: Double = photoWidth / frameWidth
    /// the offset of the photo from the top and left edges
    /// as a ratio relative to the photo width
    static  let photoPolaroidOffsetRatio: Double = photoOffset / 88.0
    /// the offset of the photo text area from the top of the image
    /// relative to the photo height
    static let textYOffsetRatio: Double = (photoHeight + photoOffset) / frameHeight
}


struct PolaroidView<PolaroidContent: View, AnnotationContent: View>: View {
    private let frameStyle: any ShapeStyle
    private let photoBackgroundColor: Color
    
    @ViewBuilder var polaroidContent: () -> PolaroidContent
    @ViewBuilder var annotationContent: () -> AnnotationContent
    
    init(frameStyle: any ShapeStyle = .polaroidFrame, photoBackgroundColor: Color = .black, polaroid polaroidContent: @escaping () -> PolaroidContent, annotation annotationContent: @escaping () -> AnnotationContent) {
        self.frameStyle = frameStyle
        self.photoBackgroundColor = photoBackgroundColor
        self.polaroidContent = polaroidContent
        self.annotationContent = annotationContent
    }

    
    @ViewBuilder
    var body: some View {
        Rectangle()
            .aspectRatio(Polaroid.frameAspectRatio, contentMode: .fit)
            .foregroundStyle(AnyShapeStyle(frameStyle))
            .overlay {
                GeometryReader { proxy in
                    // MARK: - photo content area
                    ZStack {
                        Rectangle()
                            .foregroundStyle(photoBackgroundColor)
                        polaroidContent()
                    }
                    .frame(
                        width: proxy.size.width * Polaroid.photoPolaroidWidthRatio,
                        height: proxy.size.width * Polaroid.photoPolaroidWidthRatio,
                        alignment: .center
                    )
                    .mask(Rectangle())
                    .offset(x: proxy.size.width * Polaroid.photoPolaroidOffsetRatio,
                            y: proxy.size.width * Polaroid.photoPolaroidOffsetRatio)
                    
                    // MARK: - annotation content area
                    annotationContent()
                        .frame(
                            width: proxy.size.width * Polaroid.photoPolaroidWidthRatio,
                            height: proxy.size.height * (1.0 - Polaroid.textYOffsetRatio),
                            alignment: .center
                        )
                        .mask(Rectangle())
                        .offset(x: proxy.size.width * Polaroid.photoPolaroidOffsetRatio,
                                y: proxy.size.height * Polaroid.textYOffsetRatio)
                }
            }
    }
    
    
}

#Preview("SampleImage") {
    let uiImage = UIImage(named: "pexels-photo-169524-medium.jpeg")!
    
    return PolaroidView {
        VStack {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    } annotation: {
        VStack {
            Text("A very cute dachshund!")
                .font(Constants.Fonts.handwritingLarge)
        }
    }
    .shadow(color: .prowlrViolet.opacity(0.5), radius: 4)
    .padding()
}



#Preview("Content Zones") {

    PolaroidView(frameStyle: .prowlrMagenta) {
        Rectangle()
            .foregroundStyle(.prowlrBlue)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Text("Photo Content Zone")
                    .font(Constants.Fonts.handwritingLarge)
            }
    } annotation: {
        Rectangle()
            .foregroundStyle(.prowlrBlue.opacity(0.3))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Text("Annotation Content Zone")
                    .font(Constants.Fonts.handwritingLarge)
            }
    }
    .padding()
}
