//
//  StylizedButton.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

/// A View that places adapst placement of content based on vertical size class.
struct AdaptiveStack<Content: View>: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if verticalSizeClass == .regular {
            VStack {
                content
            }
        } else {
            HStack {
                content
            }
        }
    }
}

private struct PreviewHelper: View {
    @State private var model: ColorModel = .pantoneOrange

    var body: some View {
        AdaptiveStack {
            Rectangle()
                .fill(.red)
            Rectangle()
                .fill(.green)
            Rectangle()
                .fill(.blue)
        }
        .padding()
    }
}

struct AdaptiveStack_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHelper()
            .previewDisplayName("portrait")
            .previewInterfaceOrientation(.portrait)
        PreviewHelper()
            .previewDisplayName("landscape")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
