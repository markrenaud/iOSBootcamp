//
//  DocumentsExplorer.swift
//  Created by Mark Renaud (2023).
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
                            Text("no files found")
                            Text("why not copy a JSON file here?")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                    }
                    ForEach(files) { file in
                        Text(file.filename)
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationTitle("User Documents")
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
