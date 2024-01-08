//
//  Constants.swift
//  Created by Mark Renaud (2023).
//

import Foundation

enum Constants {
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
        
        func url(for jsonFile: Constants.JSONFile) -> URL {
            url.appending(path: jsonFile.name)
        }
        
        /// Check if a **file** exists in the directory and is reachable.
        func fileExists(_ jsonFile: Constants.JSONFile) -> Bool {
            let checkURL = url(for: jsonFile)
            
            // ensure the url actually represents a file and not something else
            guard checkURL.isFileURL else {
                return false
            }
            do {
                return try checkURL.checkResourceIsReachable()
            } catch {
                return false
            }
        }
    }
    
    enum JSONFile: String {
        case apis = "apilist.json"
        case users = "aboveandbeyond.json"
        
        var name: String { rawValue }
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
    
    enum Symbols: String {
        case photoPlaceholder = "person.circle.fill"
        case apiTab = "cloud.rainbow.half.fill"
        case userTab = "person.fill"
        case documentsTab = "folder.fill.badge.person.crop"
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
