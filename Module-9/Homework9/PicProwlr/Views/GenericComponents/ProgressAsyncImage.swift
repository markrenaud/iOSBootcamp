//
//  ProgressAsyncImage.swift
//  Created by Mark Renaud (2024).
//


import SwiftUI

struct ProgressAsyncImage<PlaceholderContent: View, ImageContent: View>: View {
    @State private var downloadManager: DownloadManager?
    @State private var state: DownloadState = .pending
    @State private var image: Image? = nil
    
    let url: URL
    
    @ViewBuilder var placeholderContent: (_ progress: Double) -> PlaceholderContent
    @ViewBuilder var imageContent: (_ image: Image) -> ImageContent
    
    var body: some View {
        
        VStack {
            switch state {
            case .pending:
                placeholderContent(0.0)
            case .downloading(let progress):
                switch progress {
                case .indeterminate:
                    placeholderContent(0.0)
                case .percent(let progress):
                    placeholderContent(progress)
                }
            case .completed:
                if let image {
                    imageContent(image)
                } else {
                    EmptyView()
                }
            case .failed:
                Image(systemName: "exclamationmark.triangle")
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(color: .black, radius: 10)
                    .padding()
            }
        }
        .onAppear {
            // Initialise the download manager and start the
            // download when the view appears
            self.downloadManager = DownloadManager(
                endpoint: url,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                onStateChange: { newState in
                    withAnimation {
                        self.state = newState
                    }
                }
            )
            beginDownload()
        }
    }
    
    /// Starts the download process and updates the image state upon completion.
    func beginDownload() {
        guard let downloadManager else { return }
        Task {
            let data = try await downloadManager.download()
            // Drop back to directly loading CGImage
            // rather than UIImage to improve
            // cross platform compatibility.
            // All platforms can create a SwiftUi
            // image from a CGImage.
            let cgImage = try CGImage.load(from: data)
            await MainActor.run {
                withAnimation {
                    self.image = Image(cgImage, scale: 1.0, label: Text("Downloaded Image"))
                }
            }
        }
    }
}

#Preview {
    let sampleURL = URL(string: "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg")!
    return VStack {
        Text("slow with network link conditioner")
        Spacer()
        ProgressAsyncImage(url: sampleURL) { progress in
            ProgressView(value: progress, total: 1.0)
        } imageContent: { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .padding()
        Spacer()
    }
}
