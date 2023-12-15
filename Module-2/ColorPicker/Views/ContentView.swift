//
//  ContentView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct ContentView: View {
    @State var model: ColorModel
    @State private var pickedColor: Color
    
    init(model: ColorModel) {
        self.model = model
        self.pickedColor = model.color
    }
    
    var body: some View {
        AdaptiveStack {
            VStack {
                Text("Color Picker")
                    .font(Constants.Typography.title)
                
                Rectangle()
                    .foregroundStyle(pickedColor)
                    .overlay {
                        Rectangle()
                            .strokeBorder(lineWidth: Constants.Styling.pickerBorderWidth)
                            .foregroundStyle(.pickerBorder)
                    }
            }
            VStack {
                RGBSliders(
                    red: $model.red,
                    green: $model.green,
                    blue: $model.blue,
                    allowedRange: ColorModel.allowedColorRange
                )
                
                StylizedButton("Set Color") { pickColor() }
            }
        }
        .padding()
    }
    
    /// Updates the displayed color to the model color.
    func pickColor() {
        pickedColor = model.color
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .pantoneOrange)
    }
}
