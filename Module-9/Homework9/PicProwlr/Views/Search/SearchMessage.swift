//
//  SearchMessage.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

struct SearchMessage: View {
    enum IconRotation: Double {
        case upright = 0.0
        case upsideDown = 180.0
    }

    private let message: String
    private let rotationDegrees: Double
    private let animated: Bool

    init(_ message: String, icon: IconRotation = .upright, animated: Bool = false) {
        self.message = message
        self.rotationDegrees = icon.rawValue
        self.animated = animated
    }

    var body: some View {
        VStack {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.prowlrBlue)
                .fontWeight(.bold)

            // The logo to display, which can be either static or animated.
            owlLogo
                .frame(maxHeight: 100)
                .rotationEffect(.degrees(rotationDegrees))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    @ViewBuilder
    var owlLogo: some View {
        if animated {
            // Display the animated owl logo when `animated` is true.
            // Putting the progress at 1.0 (100%) shows a 'filled'
            // owl, but with the eyebrow animation continuing.
            AnimatedProgressOwl(progress: 1.0)
        } else {
            Image(.prowlr)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(color: .prowlrBlue, radius: 5)
                .padding()
        }
    }
}

#Preview("Animated") {
    ZStack {
        ProwlrGradient()
        SearchMessage("searching ...", icon: .upright, animated: true)
    }
}

#Preview("Still") {
    ZStack {
        ProwlrGradient()
        SearchMessage("something went wrong", icon: .upsideDown)
    }
}
