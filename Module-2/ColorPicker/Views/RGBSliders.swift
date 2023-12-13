//
//  RGBSliders.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct RGBSliders: View {
    @Binding var red: Int
    @Binding var green: Int
    @Binding var blue: Int
    
    let allowedRange: ClosedRange<Int>
    
    var body: some View {
        VStack {
            /// Grid used to ensure edges of each slider always align
            /// and that each value label width is equal (even with dynamic type size)
            Grid {
                // red
                headerRow(title: "Red")
                sliderRow(value: $red, accentColor: .red)
                
                // green
                headerRow(title: "Green")
                sliderRow(value: $green, accentColor: .green)
                
                // blue
                headerRow(title: "Blue")
                sliderRow(value: $blue, accentColor: .blue)
            }
        }
    }
    
    /// Creates a header GridRow for the color component
    func headerRow(title: String) -> some View {
        GridRow {
            Text(title)
                .font(Constants.Typography.label)
            /// This is a slightly hacky way of ensuring that enough space
            /// is left in the `sliderRow` to display the maximum number
            /// of digits possible at any dynamic type variant - while also allowing
            /// the maximum width possible for the slider
            Text("\(allowedRange.upperBound)")
                .font(Constants.Typography.boldLabel)
                .foregroundStyle(.clear)
        }
    }
    
    /// Creates a slider GridRow for the color component
    func sliderRow(value: Binding<Int>, accentColor: Color) -> some View {
        GridRow {
            IntegerSlider(value: value, range: allowedRange, accentColor: accentColor)
            Text("\(value.wrappedValue)")
                .font(Constants.Typography.boldLabel)
                .gridColumnAlignment(.trailing)
        }
    }
}

private struct PreviewHelper: View {
    @State private var model: ColorModel = .pantoneOrange
    
    var body: some View {
        RGBSliders(
            red: $model.red,
            green: $model.green,
            blue: $model.blue,
            allowedRange: ColorModel.allowedColorRange
        )
        .padding()
    }
}

struct RGBSliders_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHelper()
            .previewDisplayName("light")
            .preferredColorScheme(.light)
        
        PreviewHelper()
            .previewDisplayName("dark")
            .preferredColorScheme(.dark)
    }
}
