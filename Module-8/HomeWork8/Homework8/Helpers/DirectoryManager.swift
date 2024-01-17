//
//  DirectoryManager.swift
//  Created by Mark Renaud (2024).
//

import Foundation

struct DirectoryManager {
    /// Represents a file within the directory.
    struct File: Identifiable {
        let url: URL
        let lastModified: Date?
        var filename: String { url.lastPathComponent }
        var id: String { url.absoluteString }

        func delete() throws {
            try FileManager.default.removeItem(at: url)
        }
    }

    let url: URL

    init(_ directory: Constants.Directory) {
        self.url = directory.url
    }

    /// Enumerates and returns the files within the directory.
    func enumerateFiles() -> [DirectoryManager.File] {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: [.contentModificationDateKey],
                options: []
            )
            return fileURLs.map {
                let resourceValues = try? $0.resourceValues(forKeys: [.contentModificationDateKey])
                return DirectoryManager.File(url: $0, lastModified: resourceValues?.contentModificationDate)
            }
        } catch {
            // fail gently - with just a log
            QuickLog.model.error("unable to enumarate: \(url) - \(error.localizedDescription)")
            return []
        }
    }
}
