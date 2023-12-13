//
//  StylizedButton.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct StylizedButton: View {
    let title: String
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Text(title)
            .font(Constants.Typography.boldLabel)
            .foregroundStyle(.buttonAccent)
            .padding(Constants.Styling.buttonPadding)
            .background(
                RoundedRectangle(cornerRadius: Constants.Styling.cornerRadius)
                    .fill(.buttonBackground)
            )
            .overlay {
                RoundedRectangle(cornerRadius: Constants.Styling.cornerRadius)
                    .strokeBorder(lineWidth: Constants.Styling.borderWidth)
                    .foregroundStyle(.buttonAccent)
            }
            // define content shape, so whole button remains tappable
            // even if background is set to clear
            .contentShape(RoundedRectangle(cornerRadius: Constants.Styling.cornerRadius))
            .onTapGesture { action() }
    }
}

struct StylizedButton_Previews: PreviewProvider {
    static var previews: some View {
        StylizedButton("Set Color") { print("Pressed!!") }
            .previewDisplayName("light")
            .preferredColorScheme(.light)
        
        StylizedButton("Set Color") { print("Pressed!!") }
            .previewDisplayName("dark")
            .preferredColorScheme(.dark)
    }
}
