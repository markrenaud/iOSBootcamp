//
//  DownloadState.swift
//  Created by Mark Renaud (2023).
//

import SwiftUI

enum DownloadState: Equatable {
    enum DownloadProgress: Equatable {
        /// Request headers do *NOT* implement`Content-Length` and download progress is indeterminate.
        case indeterminate
        /// Request headers implement `Content-Length` and downloading has progressed to the percent (0.0-1.0).
        case percent(Double)
    }

    /// The download had not been requested
    case pending
    /// The download request is checking headers to see if `Content-Length` is supported
    case downloading(progress: DownloadProgress)
    /// The download has successfully completed
    case completed
    /// The download failed.
    case failed

    /// Returns a string representation of the download state.
    var label: String {
        switch self {
        case .pending:
            return "pending"
        case .downloading(let progress):
            return "downloading: \(progress)"
        case .completed:
            return "completed"
        case .failed:
            return "failed"
        }
    }
}
