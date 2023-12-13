//
//  ContentView.swift
//  Created by Mark Renaud (2023).
//
    

import SwiftUI

fileprivate extension Double {
    /// Clamps a `Double` to a closed range.
    /// If the `Double` falls outside the range, the returned value will be the lower or upper range
    /// of the range.
    /// If the `Double` falls within the range, the returned value will be the original value..
    func clamped(_ range: ClosedRange<Double>) -> Double {
        if self < range.lowerBound { return range.lowerBound }
        if self > range.upperBound { return range.upperBound }
        return self
    }
}

struct RGBModel {
    /// The `red` component value.
    /// The value should be between 0.0 and 1.0.
    var red: Double
    /// The `green` component value.
    /// The value should be between 0.0 and 1.0.
    var green: Double
    /// The `blue` component value.
    /// The value should be between 0.0 and 1.0.
    var blue: Double

    init(red: Double = 0.5, green: Double = 0.5, blue: Double = 0.5) {
        self.red = red.clamped(0.0...1.0)
        self.green = green.clamped(0.0...1.0)
        self.blue = blue.clamped(0.0...1.0)
    }
    
    /// The SwiftUI `Color` based on the red, green, and blue component values.
    var color: Color {
        Color(
            red: red.clamped(0.0...1.0),
            green: green.clamped(0.0...1.0),
            blue: blue.clamped(0.0...1.0)
        )
    }
}

extension RGBModel {
    /// An RGBModel that represents the color Sky Blue.
    static let skyBlue = RGBModel(red: 0.4627, green: 0.8392, blue: 1.0)
}

struct ContentView: View {
    
    @State private var model: RGBModel
    @State private var pickedColor: Color
    
    init(model: RGBModel) {
        self.model = model
        self.pickedColor = model.color
    }
    
    var body: some View {
        VStack {
            Text("Color Picker")
                .font(.largeTitle)
            RoundedRectangle(cornerRadius: 0.0)
                .foregroundStyle(pickedColor)
            colorSlider(value: $model.red, name: "Red")
            colorSlider(value: $model.green, name: "Green")
            colorSlider(value: $model.blue, name: "Blue")
            Button("Set Color") { pickColor() }
        }
        .padding()
    }
    
    /// A color slider
    func colorSlider(value: Binding<Double>, name: String) -> some View {
        VStack {
            Text(name)
            HStack {
                Slider(value: value, in: 0.0...1.0, step: 1.0 / 255.0)
                Text("\(Int(value.wrappedValue * 255.0))")
            }
        }
    }
    
    /// Updates the displayed color to the model color.
    func pickColor() {
        pickedColor = model.color
    }
}

#Preview {
    ContentView(model: RGBModel.skyBlue)
}
