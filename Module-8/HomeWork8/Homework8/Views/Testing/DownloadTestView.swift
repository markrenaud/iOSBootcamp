//
//  DownloadTestView.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

struct DownloadTestView: View {
    
    private let unsplashURL = URL(string: "https://unsplash.com/photos/pSNM2lEOnTo/download")!
    private let publicAPIsURL = URL(string: "https://api.publicapis.org/entries")!
    private let invalidURL = URL(string: "https://i.do.not.exist")!
    private let mainBundleJSON = Constants.APIModule.mainBundleURL
    
    @State private var downloadState: DownloadState = .pending
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Use Network Link Conditioner")
                    .fontWeight(.light)
                    .foregroundStyle(.red)
                Divider()
                
                Button("Unsplash") { request(endpoint: unsplashURL) }
                Text("remote: supports content length")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Divider()
                
                Button("Public Entries") { request(endpoint: publicAPIsURL) }
                Text("remote: does not support content length")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Divider()
                
                Button("Invalid Remote") { request(endpoint: invalidURL) }
                Text("remote: resource that does not exist")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Divider()

                
                Button("Local File") { request(endpoint: mainBundleJSON) }
                Text("local: ignore content length")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Divider()
                
                DownloadStateSymbolView(state: downloadState)
                    .padding()
            }
            .navigationTitle("DownloadState Testing View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func request(endpoint: URL) {
        // reset state
        downloadState = .pending
        
        Task {
            let dm = DownloadManager(
                endpoint: endpoint,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData) { newState in
                    // this callback is returned on MainActor so can directly
                    // assign to local UI state here
                    downloadState = newState
                }
            let data = try await dm.download()
            print("received: \(data.count) bytes")
        }
    }
    
}

#Preview {
    DownloadTestView()
}
