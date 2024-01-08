//
//  ModularStore.swift
//  Created by Mark Renaud (2023).
//

import Foundation

enum ModularStoreError: Error {
    case unableToLoadFrom(urls: [URL])
}

/// A Generic Store that manages a Codable object and allows access to a specific collection within it.
/// The `projectedKeyPath` is used to access a collection within the Codable object.
class ModularStore<StoredType: Codable, ProjectedPropertyType: BidirectionalCollection>: ObservableObject {
    @Published var codable: StoredType
    private var projectedKeyPath: KeyPath<StoredType, ProjectedPropertyType>

    /// A projected collection from within the underlying codable object that serves as the main
    /// data interacted with. This collection is accessed via the `projectedKeyPath`.
    var projectedIterable: ProjectedPropertyType {
        get {
            codable[keyPath: projectedKeyPath]
        }
        set {
            // we can only write back to the property if it is mutable
            switch projectedKeyPath {
            case let writabledKeyPath as WritableKeyPath<StoredType, ProjectedPropertyType>:
                codable[keyPath: writabledKeyPath] = newValue
            default:
                // The key path is not writable or does not match the expected type
                QuickLog.model.error("Attempted to write to an immutable projected property '\(projectedKeyPath)' on '\(StoredType.self)' - operation ignored.")
            }
        }
    }

    init(initialCodable: StoredType, projectedKeyPath: KeyPath<StoredType, ProjectedPropertyType>) {
        self.codable = initialCodable
        self.projectedKeyPath = projectedKeyPath
    }
}

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
}
