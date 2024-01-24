//
//  ModularStore+JSON.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

// Methods to read / write JSON
extension ModularStore {

    /// Loads the first successful JSON of `StoredType`  into the store from an array of `URL`s.
    /// Iterates through each `URL` until a valid JSON is found and decoded,
    /// otherwise throws an error if none succeed.
    func readJSON(using jsonURLs: [URL]) throws {
        for jsonURL in jsonURLs {
            do {
                guard try jsonURL.checkResourceIsReachable() else {
                    // a valid file is not reachable at the url - continue
                    // to next URL
                    QuickLog.model.info("Failed to load \(jsonURL.absoluteString) - file not available.")
                    continue
                }
                // try to load and decode
                let data = try Data(contentsOf: jsonURL)
                codable = try JSONDecoder().decode(StoredType.self, from: data)
                QuickLog.model.info("Loaded \(jsonURL.absoluteString) as `\(StoredType.self)` into GenericStore.codable.")
                return
            } catch {
                // url failed, continue to next in loop
                QuickLog.model.info("Unable to load \(jsonURL.absoluteString) as `\(StoredType.self)` - \(error).")
                continue
            }
        }
        // all the URLs given silently failed
        // now throw an error.
        throw ModularStoreError.unableToLoadFrom(urls: jsonURLs)
    }

    
    //// Loads the first successful JSON of `StoredType`  into the store from an array of `URL`s
    /// computed from stored resource preferences via the Download Manager.
    ///
    /// Iterates through each `URL` until a valid JSON is found and decoded,
    /// otherwise throws an error if none succeed.
    func downloadJSON() async throws {
        try await downloadJSON(using: enabledResourcePreferenceURLs)
    }
    
    
    /// Loads the first successful JSON of `StoredType`  into the store from an array of `URL`s
    /// using the Download Manager.
    ///
    /// Iterates through each `URL` until a valid JSON is found and decoded,
    /// otherwise throws an error if none succeed.
    func downloadJSON(using jsonURLs: [URL]) async throws {
        for jsonURL in jsonURLs {
            do {
                let dm = DownloadManager(endpoint: jsonURL) { newState in
                    // the callback is specified to run on the MainActor
                    // so we can directly assign here
                    self.downloadState = newState
                    print("-> \(newState)")
                }
                let decoded = try await dm.download(type: StoredType.self)
                await MainActor.run {
                    codable = decoded
                }
                
                // check if we are to cache the downloaded json
                // but only cache if the url is not already a cached version
                if shouldCacheDownloads && jsonURL != StoredType.documentsURL {
                    try cacheToDocuments()
                }
                
                // if we made it heare, we succesfully loaded the data into the store from the endpoint
                // log, and exit out of method
                QuickLog.model.info("Loaded \(jsonURL.absoluteString) as `\(StoredType.jsonFile)` into the store.")
                return
            } catch {
                // failed to download from the url, continue to the next url in the loop
                QuickLog.model.info("Unable to load \(jsonURL.absoluteString) as `\(StoredType.self)` - \(error).")
                continue
            }
        }
        // all the URLs given failed
        // we will manually set the download state to failed here
        // to cover the edge case that no urls were provided - and thus
        // no callbacks from the DownloadManager
        await MainActor.run {
            withAnimation {
                downloadState = .failed
            }
        }
        // now throw an error.
        throw ModularStoreError.unableToLoadFrom(urls: jsonURLs)
    }

    /// Saves the `Store`'s `codable` property as JSON to the specified `URL`.
    /// If `pretty` is true, the JSON will be formatted for readability.
    func writeJSON(to destinationURL: URL, pretty: Bool = true) throws {
        let jsonEncoder = JSONEncoder()
        if pretty {
            jsonEncoder.outputFormatting = [.prettyPrinted]
        }
        let data = try jsonEncoder.encode(codable)
        try data.write(to: destinationURL, options: [.atomic])
    }
    
    /// Caches a copy of the current `Store`'s `codable` property to the user's Documents
    /// directory.
    /// If `pretty` is true, the JSON will be formatted for readability.
    func cacheToDocuments(pretty: Bool = true) throws {
        try writeJSON(to: StoredType.documentsURL, pretty: pretty)
        QuickLog.model.info("Cached store to Documents directory as: \(StoredType.jsonFile)")
    }
}
