//
//  ModularStore.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

enum ModularStoreError: Error {
    case unableToLoadFrom(urls: [URL])
}

/// A Generic Store that manages a Codable object and allows access to a specific collection within it.
/// The `projectedKeyPath` is used to access a collection within the Codable object.
class ModularStore<StoredType: Codable, ProjectedPropertyType: BidirectionalCollection>: ObservableObject where StoredType: ModularStoreResourcePreferenceProvider {
    @Published var codable: StoredType
    @Published var downloadState: DownloadState = .pending
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
    
    /// Reads the resource preferences from user defaults
    var resourcePreferences: [ResourcePreference] {
        guard
            let jsonData = UserDefaults.standard.data(forKey: Constants.PreferenceKey.resources),
            let preferences = [ResourcePreference].from(json: jsonData)
        else {
            return .defaults
        }
        return preferences
    }
    
    /// Returns enabled json resource urls in order of preference from user defaults
    var enabledResourcePreferenceURLs: [URL] {
        return resourcePreferences.compactMap { resourcePreference in
            guard resourcePreference.enabled else { return nil }
            return StoredType.url(location: resourcePreference.location)
        }
    }
    
    /// Reads the caching preference from user defaults
    var shouldCacheDownloads: Bool {
        return UserDefaults.standard.bool(forKey: Constants.PreferenceKey.cache)
    }
}
