//
//  DocumentsExplorer.swift
//  Created by Mark Renaud (202r).
//

import SwiftUI

/// A view that displays a list of documents in the user's documents directory with the ability to delete them.
struct DocumentsExplorer: View {
    @State private var files: [DirectoryManager.File] = []
    let docsManager = DirectoryManager(.userDocuments)
    

    var body: some View {
        NavigationStack {
            VStack {
                Text("swipe to delete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                List {
                    if files.isEmpty {
                        VStack(alignment: .leading) {
                            Text("no cached files found")
                            Text("is caching enabled?")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                    }
                    ForEach(files) { file in
                        FileRowView(file: file)
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationTitle("Cached Documents")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                updateFileList()
            }
        }
    }
    
    /// Updates the list of files displayed to the user.
    func updateFileList() {
        files = docsManager.enumerateFiles()
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let fileForDelection = files[offset]
            try? fileForDelection.delete()
        }
        updateFileList()
    }
}

#Preview {
    DocumentsExplorer()
}
