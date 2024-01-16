//
//  ProgressOwl.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

/// Displays an owl image with a progress overlay.
struct ProgressOwl: View {
    /// The current progress as a double between 0.0 and 1.o
    let progress: Double

    var body: some View {
        Image(.prowlrBody)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .shadow(color: .prowlrBlue, radius: 15.0 * progress)
            .overlay(
                GeometryReader { proxy in
                    Image(.prowlrBodyOutline)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .mask(
                            VStack {
                                Rectangle()
                                    .foregroundStyle(.white.opacity(0.8))
                                    .frame(height: proxy.size.height * (1.0 - progress))
                                Spacer()
                            }
                        )
                        .blendMode(.colorBurn)
                }
            )
    }
}

#Preview {
    ZStack {
        ProwlrGradient()
        VStack {
            ProgressOwl(progress: 0.25)
            ProgressOwl(progress: 0.75)
                .frame(height: 200)
        }
    }
}
