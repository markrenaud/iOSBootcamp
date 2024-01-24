//
//  FileRowView.swift
//  Created by Mark Renaud (202r).
//

import SwiftUI

struct FileRowView: View {
    
    let file: DirectoryManager.File
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(file.filename)
            Text("cached: \(styled(date: file.lastModified))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    
    /// Styles an optional `Date` as a `String` for UI.
    private func styled(date: Date?) -> String {
        guard let date else { return "??" }
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df.string(from: date)
    }
}

#Preview {
    FileRowView(file: DirectoryManager.File(url: APIEntries.mainBundleURL, lastModified: .now))
}
