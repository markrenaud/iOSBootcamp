//
//  ProwlrGradient.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

struct ProwlrGradient: View {
    var body: some View {
        Rectangle()
            .foregroundStyle(Gradient(colors: [.prowlrViolet, .prowlrPurple]))
            .ignoresSafeArea(.container)
    }
}

#Preview {
    ProwlrGradient()
}
