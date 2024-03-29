//
//  AnimatedProgressOwl.swift
//  Created by Mark Renaud (2024).
//


import SwiftUI

struct AnimatedProgressOwl: View {
    /// The angle of rotation for the eyebrows in degrees.
    @State private var eyebrowRotation: Double = -Constants.Animation.maxEyebrowRotation
    /// Value between 0.0 and 1.0 representing completion progress.
    let progress: Double
    let eyebrowAnimation = Animation.interactiveSpring.repeatForever(autoreverses: true)
    
    var body: some View {
            ZStack(alignment: .center) {
                ProgressOwl(progress: progress)
                Image(.prowlrEybrows)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotationEffect(.degrees(eyebrowRotation), anchor: .center)
        }
        .padding()
        .onAppear {
            withAnimation(eyebrowAnimation) {
                // toggle direction of eyebrow offset
                eyebrowRotation *= -1.0
            }
        }
    }
}

fileprivate struct PreviewHelper: View {
    @State private var progress: Double = 0.0

    /// The duration (in seconds) that the preview animation should take to complete.
    let previewSeconds: TimeInterval = 10.0
    
    var body: some View {
        VStack {
            AnimatedProgressOwl(progress: progress)
            Button("Reset") {
                progress = 0.0
                withAnimation(.linear(duration: previewSeconds)) {
                    self.progress = 1.0
                }
            }
            .disabled(progress < 1.0)
        }
        .onAppear {
            withAnimation(.linear(duration: previewSeconds)) {
                self.progress = 1.0
            }
        }
    }
    
}


#Preview {
    ZStack {
        ProwlrGradient()
        PreviewHelper()
    }
}
