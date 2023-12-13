//
//  StylizedButton.swift
//  Created by Mark Renaud (2023).
//


import SwiftUI

#warning("Fix Documentation")
/// A View that places content in a `VStack` when the vertical size class is `.regular`,
/// otherwise a `HStack`.
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

fileprivate struct PreviewHelper: View {
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

