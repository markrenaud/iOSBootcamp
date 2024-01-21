//
//  DownloadManager.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

enum DownloadManagerError: Error {
    /// A download of the managed endpoint is already in progress.
    /// Cancel or wait for existing download to finish before trying again.
    case alreadyDownloading(url: URL)
    /// An unexpected HTTP respons status code was received.
    case unexpectedHTTPResponse(statusCode: Int)
}

/// A download manager that handles a single endpoint.
/// The manager publishes its state / progression for observation by interested views.
class DownloadManager: NSObject {
    private var state: DownloadState = .pending {
        didSet {
            // Log any state change to console for debugging purposes
            QuickLog.service.info("[DownloadManager]: State Change: \(oldValue.label) -> \(state.label)")
        }
    }
    
    let endpoint: URL
    let cachePolicy: URLRequest.CachePolicy
    /// A callback that is run whenever the state is changed.
    ///
    /// This callback is run on the MainActor.
    let stateChangeCallback: ((_ newState: DownloadState) -> Void)?
    
    private var downloadContinuation: CheckedContinuation<Data, Error>? = nil
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = cachePolicy
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    init(
        endpoint: URL,
        cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData,
        onStateChange stateChangeCallback: ((_ newState: DownloadState) -> Void)? = nil
    ) {
        self.endpoint = endpoint
        self.cachePolicy = cachePolicy
        self.stateChangeCallback = stateChangeCallback
    }
    
    deinit {
        // From Apple Documentation:
        // > The session object keeps a strong reference to the delegate until your app exits
        // > or explicitly invalidates the session. If you don’t invalidate the
        // > session, your app leaks memory until the app terminates.
        //
        // As we are referencing `self` for delegate, ensure that we invalidate
        // to avoid retain cycle when going out of scope.
        session.invalidateAndCancel()
    }
    
    func download() async throws -> Data {
        QuickLog.service.info("[DownloadManager]: download requested from \(endpoint.absoluteString)")
        // check if there is an existing continuation - and throw
        // if currently already downloading
        if downloadContinuation != nil {
            throw DownloadManagerError.alreadyDownloading(url: endpoint)
        }
        // there is currently not a continuation - and one will be assigned
        // ensure we clean continuation after the task throws or returns
        defer {
            downloadContinuation = nil
        }
        
        // reset download state
        await updateState(.pending)
        
        return try await withCheckedThrowingContinuation { continuation in
            // keep a reference to the continuation for the
            // URLSessionDownloadDelegate methods to use
            downloadContinuation = continuation
            
            // Using older APIs to ensure delegate methods get called correctly
            // see: https://developer.apple.com/forums/thread/738541 (among others)
            let request = URLRequest(url: endpoint)
            let task = session.downloadTask(with: request)
            task.resume()
        }
    }
    
    func download<T: Codable>(type: T.Type) async throws -> T {
        let data = try await download()
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// Update the published state on the main actor.
    @MainActor
    private func updateState(_ newState: DownloadState) {
        // update only if the state has changed
        guard state != newState else { return }

        state = newState
        if let stateChangeCallback {
            stateChangeCallback(newState)
        }
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        // set state initially to indeterminate:
        // once the our first chunk of data arrives
        // urlSession(_ session:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)
        // can determine if we can calculate progress percentage
        Task { await updateState(.downloading(progress: .indeterminate)) }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // only check the error case, successful download case will be handled by:
        // urlSession(_ session:downloadTask:didFinishDownloadingTo:)
        if let error {
            // update state for UI
            Task { await updateState(.failed) }
            // rethrow the error
            downloadContinuation?.resume(throwing: error)
            QuickLog.service.error("[\(endpoint.absoluteString)]: Download failed - \(error.localizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // handle the case where the download shows progress state:
        // only handle if:
        // - the transfer size is known
        // - the url is not of a file type
        // (accessing a `file://` URL  may provide chunks of data, however, as
        // this occurs locally and occurs quickly, changes in UI based of this
        // property may be confusing to the user - ignore for file type URLs)
        if endpoint.isFileURL { return }
        if downloadTask.countOfBytesExpectedToReceive != NSURLSessionTransferSizeUnknown {
            // we can accurately calculate the progress
            // so we should update the state for UI
            let percentComplete = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            Task { await updateState(.downloading(progress: .percent(percentComplete))) }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // if downloading from a remote URL (rather than a file), the HTTP
        // reponse status code should be checked to ensure we didn't
        // "successfully download" a file we weren't expecting (eg. a 404 page).
        if
            let httpResponse = downloadTask.response as? HTTPURLResponse,
            !(200 ..< 300).contains(httpResponse.statusCode)
        {
            // non success HTTP response
            QuickLog.service.error("[\(endpoint.absoluteString)]: HTTP Status Code \(httpResponse.statusCode)")
            Task { await updateState(.failed) }
            downloadContinuation?.resume(throwing: DownloadManagerError.unexpectedHTTPResponse(statusCode: httpResponse.statusCode))
        } else {
            // load the data from the download destination
            // and resume continuation
            do {
                let data = try Data(contentsOf: location)
                Task { await updateState(.completed) }
                downloadContinuation?.resume(returning: data)
            } catch {
                // rethrow error to continuation
                Task { await updateState(.failed) }
                downloadContinuation?.resume(throwing: error)
            }
        }
        
        // cleanup the received temporary file in background
        Task.detached(priority: .background) {
            try FileManager.default.removeItem(at: location)
            QuickLog.service.info("[DownloadManger]: Cleaned up temporary download file: \(location.lastPathComponent)")
        }
    }
}
