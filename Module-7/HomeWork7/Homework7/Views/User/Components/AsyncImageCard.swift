//
//  AsyncImageCard.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

struct AsyncImageCard: View {
    let title: String
    let subtitle: String
    let imageURL: URL?
    
    var body: some View {
        HStack {
            AsyncImage(url: imageURL) { img in
                img
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fill)
                    .mask(Circle())
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 1.0)
                    )
            } placeholder: {
                Image(systemName: Constants.Symbols.photoPlaceholder.name)
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 80, height: 80)
            Spacer()
            VStack(alignment: .trailing) {
                Text(title)
                    .font(.title2)
                Text(subtitle)
                    .foregroundStyle(.secondary)
                
            }
        }
    }
}

#Preview {
    Form {
        AsyncImageCard(
            title: "Paulina Bonnet",
            subtitle: "29 years old",
            imageURL: URL(string: "https://randomuser.me/api/portraits/women/81.jpg")!
        )
    }
}
