//
//  PillTag.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

/// `PillTag` is a view component that displays a text label within a colored pill-shaped tag.
struct PillTag: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(.caption2, design: .monospaced, weight: .light))
            .bold()
            .foregroundStyle(color)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(color.opacity(0.3))
            )
    }
}

#Preview {
    PillTag(text: "HTTPS", color: .cyan)
}
