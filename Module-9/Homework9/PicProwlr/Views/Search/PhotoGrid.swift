//
//  PhotoGrid.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

struct PhotoGrid: View {
    let photos: [PexelsPhoto]

    // Define the layout for the grid items in the LazyVGrid.
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: Constants.Styling.gridItemMinWidth,
                           maximum: Constants.Styling.gridItemMaxWidth),
                 spacing: Constants.Styling.gridItemSpacing)
    ]

    var body: some View {
        LazyVGrid(
            columns: columns,
            spacing: Constants.Styling.gridItemSpacing,
            content: {
                ForEach(photos) { photo in
                    // Assumes that PhotoGrid is inside a NavigationStack.
                    // Pushed to detail view for individual photo
                    // with download size of `.large2x` as per homework
                    // requirements.
                    NavigationLink {
                        AsyncPhotoDetailView(photo: photo, downloadSize: .large2X)
                            .navigationTitle("#\(photo.id)")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        PexelsPolaroid(photo: photo, size: .medium)
                    }
                }
            }
        )
    }
}

#Preview {
    NavigationStack {
        PhotoGrid(photos: [.dachshund])
    }
}
