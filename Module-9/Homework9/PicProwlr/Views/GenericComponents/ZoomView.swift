//
//  ZoomView.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

fileprivate struct ContentSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(
        value: inout CGSize,
        nextValue: () -> CGSize
    ) {
        value = nextValue()
    }
}

fileprivate struct ScrollViewSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(
        value: inout CGSize,
        nextValue: () -> CGSize
    ) {
        value = nextValue()
    }
}

/// **Content requires a fixed size to calculate correctly - consider using a frame**
struct ZoomView<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    @State private var scale: Double = 1.0
    @State private var contentSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    @State private var actualContentSize: CGSize = .zero
    
    @State private var isZooming: Bool = true
    @State private var magnificationDelta: CGFloat = 1.0
    
    /*
     ==== Important Notes for future Mark ====
     
     Due to imprecision in how images are rendered on screen
     (we cannot render at subpixel precision) and the fact that
     floating-point decimal values generally do not have an exact
     binary representation, the updating of `contentSize` (via
     `ContentSizePreferenceKey`) and scale can enter a recursive
     loop.
     
     To counter this, two measures have been implemented:
     1 - A slight timing delay when first updating @State
     properties in onAppear
     2 - Explicitly stating when zooming is actively occurring
     (either from pinch gestures or through scale animations
     when `scaleToFit()` is called)
     
     */
    
    
    // min and max scale to size image at full size or
    // size that just fits inside the scroll view frame
    private var minScale: Double { min(1.0, scaleThatFits) }
    private var maxScale: Double { max(1.0, scaleThatFits) }
    
    /// Gesture to handle magnification changes
    private var zoom: some Gesture {
        MagnificationGesture()
            .onChanged { delta in
                // update zoom state
                self.isZooming = true
                self.magnificationDelta = delta
            }
            .onEnded { _ in
                var requestedScale = self.scale * self.magnificationDelta
                // clamp the final requested scale within the max/min scales
                if requestedScale < minScale { requestedScale = minScale }
                if requestedScale > maxScale { requestedScale = maxScale }
                
                // reset zoom state
                self.isZooming = false
                // reset magnification delta
                self.magnificationDelta = 1.0
                
                // update final content scale
                self.scale = requestedScale
            }
    }
    
    /// The scale ratio that 'just' fits the content inside of the ScrollViewFrame
    var scaleThatFits: Double {
        let contentAspectRatio = actualContentSize.width / actualContentSize.height
        let scrollViewAspectRatio = scrollViewSize.width / scrollViewSize.height
        
        if contentAspectRatio > scrollViewAspectRatio {
            // scale rect so the width just fits inside the frame
            // minimise precision to reduce recursion
            return (scrollViewSize.width / actualContentSize.width)
        } else {
            // scale rect so the height just fits inside the frame
            // minimise precision to reduce recursion
            return (scrollViewSize.height / actualContentSize.height)
        }
    }
    
    var body: some View {
        
        ScrollView([.horizontal, .vertical]) {
            
            content()
                .background(
                    GeometryReader { innerProxy in
                        Color.clear
                            .preference(
                                key: ContentSizePreferenceKey.self,
                                value: innerProxy.frame(in: .global).size
                            )
                    }
                )
                .scaleEffect(scale * magnificationDelta)
                .frame(width: contentSize.width, height: contentSize.height, alignment: .center)
        }
        .background(
            GeometryReader { outerProxy in
                Color.clear
                    .preference(
                        key: ScrollViewSizePreferenceKey.self,
                        value: outerProxy.frame(in: .global).size
                    )
            }
        )
        .gesture(zoom)
        .onPreferenceChange(ContentSizePreferenceKey.self) { preference in
            // get the actual content size when first appears at scale of 1.0
            if actualContentSize == .zero {
                actualContentSize = preference
            }
            // Only update content size if actively zooming to avoid
            // recursion loop
            // Perform a small amount of "debouncing" to avoid
            // preference key updating multiple times per frame
            if isZooming {
                Task {
                    try await Task.sleep(for: .seconds(0.1))
                    await MainActor.run {
                        self.contentSize = preference
                    }
                }
            }
        }
        .onPreferenceChange(ScrollViewSizePreferenceKey.self) { preference in
            self.scrollViewSize = preference
        }
        .onAppear {
            Task {
                // Briefly sleep to allow preferences to calculate before
                // fitting content.
                try await Task.sleep(for: .seconds(0.05))
                if actualContentSize != .zero && scrollViewSize != .zero {
                    await MainActor.run { scaleToFit() }
                }
            }
        }
        
    }
    
    /// Adjusts the scale to fit the content within the ScrollView's frame
    func scaleToFit() {
        // Explicitly flag start and stop of zooming
        // to avoid unnecessary preference key loops.
        isZooming = true
        withAnimation(.easeOut(duration: 0.25), {
            self.scale = scaleThatFits
        }, completion: {
            isZooming = false
        })
    }
    
    
}

#Preview {
    ZoomView() {
        Image(.previewPuppy)
        //        Rectangle()
        //            .frame(width: 500, height: 200)
    }
    .background(.yellow)
    .padding(20)
}
