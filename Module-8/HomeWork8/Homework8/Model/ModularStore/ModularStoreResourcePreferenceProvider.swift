//
//  ModularStoreResourcePreferenceProvider.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

protocol ModularStoreResourcePreferenceProvider {
    static var jsonFile: String { get }
    static var remoteEndpointURL: URL { get }
    static var mainBundleURL: URL { get }
    static var documentsURL: URL { get }
}
extension ModularStoreResourcePreferenceProvider {
    static func url(location: ResourcePreference.Location) -> URL {
        switch location {
        case .remoteServer:
            return remoteEndpointURL
        case .cachedDocument:
            return documentsURL
        case .appBundle:
            return mainBundleURL
        }
    }
}
