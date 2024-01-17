//
//  Constants.swift
//  Created by Mark Renaud (2024).
//

import Foundation

enum Constants {
    /// Constants specific to the API entries module.
    enum APIModule {
        static let title = "APIs"
        enum Symbol: String {
            case tab = "cloud.rainbow.half.fill"
            var name: String { rawValue }
        }
    }
    
    /// Constants specific to the User module.
    enum UserModule {
        static let title = "Users"
        enum Symbol: String {
            case tab = "person.2.fill"
            var name: String { rawValue }
        }
    }
    
    /// Constants specific to the Documents module.
    enum DocumentsModule {
        static let title = "Cache"
        enum Symbol: String {
            case tab = "folder.fill.badge.person.crop"
            case photoPlaceholder = "person.circle.fill"
            var name: String { rawValue }
        }
    }
    
    /// Constants specific to the Settings module.
    enum SettingsModule {
        static let title = "Settings"
        enum Symbol: String {
            case tab = "gear"
            var name: String { rawValue }
        }
    }
    
    enum Directory {
        case userDocuments
        case mainBundle
        
        var url: URL {
            switch self {
            case .userDocuments:
                return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            case .mainBundle:
                return Bundle.main.bundleURL
            }
        }
        
        func url(for fileName: String) -> URL {
            url.appending(path: fileName)
        }
        
        /// Check if a **file** exists in the directory and is reachable.
        func fileExists(_ fileName: String) -> Bool {
            let checkURL = url(for: fileName)
            
            // ensure the url actually represents a file and not something else
            guard checkURL.isFileURL else { return false }
            do {
                return try checkURL.checkResourceIsReachable()
            } catch {
                return false
            }
        }
    }
    
    struct PreferenceKey {
        static let resources = "resourcePreferences"
        static let cache = "enableAutoCache"
    }
    
    enum DateReference {
        /// A placeholder for missing dates.
        /// 1/1/1 GMT
        static let placeholder: Date = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: .gmt,
            year: 1,
            month: 1,
            day: 1
        ).date!
    }
    
    enum GeneralSymbols: String {
        case photoPlaceholder = "person.circle.fill"
        var name: String { rawValue }
    }
    
    enum Map {
        static let defaultRegionMeters: Double = 100000 // 100km
        
        enum Location {
            /// A placeholder location
            case applePark
            
            var coordinates: (latitude: Double, longitude: Double) {
                switch self {
                case .applePark:
                    return (latitude: 37.334606, longitude: -122.009102)
                }
            }
        }
    }
}
