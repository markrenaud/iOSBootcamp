//
//  SecuredProperty.swift
//  Created by Mark Renaud (2024).
//

import SwiftUI

/// A property wrapper around SecureStorage for reading/writing a value to the keychain.
@propertyWrapper struct SecuredProperty: DynamicProperty {
    @State private var value = ""
    let key: String

    init(_ key: String) {
        self.key = key

        let initialValue = (try? SecuredStorage.read(from: key)) ?? ""
        _value = State(initialValue: initialValue)
    }

    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            do {
                try SecuredStorage.write(newValue, to: key)
                value = newValue
            } catch {
                QuickLog.service.error("SecuredStorage Error: \(error)")
            }
        }
    }

    var projectedValue: Binding<String> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}
