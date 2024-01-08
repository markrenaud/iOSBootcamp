//
//  DirectoryManager.swift
//  Created by Mark Renaud (2023).
//

import Foundation

struct DirectoryManager {
    /// Represents a file within the directory.
    struct File: Identifiable {
        let url: URL
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
                includingPropertiesForKeys: [.isRegularFileKey, .isHiddenKey],
                options: []
            )
            return fileURLs.map { DirectoryManager.File(url: $0) }
        } catch {
            // fail gently - with just a log
            QuickLog.model.error("unable to enumarate: \(url) - \(error.localizedDescription)")
            return []
        }
    }
}
