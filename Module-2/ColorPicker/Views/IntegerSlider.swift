//
//  IntegerSlider.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

/// A Slider that allows selection of an integer value over a set integer range.
struct IntegerSlider: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    let accentColor: Color
    
    private var doubleValue: Binding<Double> {
        Binding {
            return Double(value)
        } set: { updatedValue in
            value = Int(updatedValue)
        }
    }
    
    var body: some View {
        Slider(
            value: doubleValue,
            in: Double(range.lowerBound)...Double(range.upperBound),
            step: 1.0   // "integer" steps
        )
        .tint(accentColor)
    }
}

fileprivate struct PreviewHelper: View {
    @State private var sliderValue: Int = 128
    
    var body: some View {
        VStack {
            IntegerSlider(
                value: $sliderValue,
                range: 0...255,
                accentColor: .red
            )
        }
        .padding()
    }
}

struct ColorSlider_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHelper()
            .previewDisplayName("light")
            .preferredColorScheme(.light)
        
        PreviewHelper()
            .previewDisplayName("dark")
            .preferredColorScheme(.dark)
    }
}
