//
//  SecuredStorage.swift
//  Created by Mark Renaud (2024).
//

import Foundation

enum SecuredStorageError: Error {
    case keyNotUTF8Representable
    case valueNotUTF8Representable
    case valueNotFoundForKey
    case keyAlreadyExists
    case keychainError(status: OSStatus)
}

/// Handles storing preference values securely in the Keychain.
///
/// The values are stored as Generic Passwords in the keychain.
struct SecuredStorage {
    /// Hide iniitializer - not required - instance methods only in struct.
    private init() {}
    
    /// Reads a secure value from the keychain for the given key.
    static func read(from key: String) throws -> String {
        let keyData = try keyData(from: key)
        var keychainQuery = keychainQuery(with: keyData)
        keychainQuery[kSecMatchLimit as String] = kSecMatchLimitOne // limit to one result
        keychainQuery[kSecReturnAttributes as String] = true // specify attributes should be returned
        keychainQuery[kSecReturnData as String] = true // specify that the value data should be returned
        
        // create a placeholder for the retrieved keychain item
        var item: CFTypeRef?
        // attempt to search for the item in the keychain
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &item)
        // handle/throw any errors if needed
        try parseKeychainStatus(status)
        
        // decode
        guard
            let keychainItem = item as? [String: Any],
            let valueData = keychainItem[kSecValueData as String] as? Data,
            let value = String(data: valueData, encoding: .utf8)
        else {
            throw SecuredStorageError.valueNotUTF8Representable
        }
        return value
    }
    
    /// Writes a value securely to the keychain for the given key.
    /// Can be used to create or update an entry.
    ///
    /// Both `key` and `value` must be UTF-8 representable strings.
    static func write(_ value: String, to key: String) throws {
        let valueData = try valueData(from: value)
        let keyData = try keyData(from: key)
        
        var keychainQuery = keychainQuery(with: keyData)
        keychainQuery[kSecValueData as String] = valueData
        
        // attempt to add the item to the keychain
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        do {
            try parseKeychainStatus(status)
        } catch SecuredStorageError.keyAlreadyExists {
            // already exists, update instead
            try update(valueData: valueData, keyData: keyData)
        } catch {
            // rethrow the error
            throw error
        }
    }
    
    /// Removes a value from the keychain for the given key.
    static func remove(key: String) throws {
        guard let keyData = key.data(using: .utf8) else { throw SecuredStorageError.keyNotUTF8Representable }
        let keychainQuery = keychainQuery(with: keyData)
        // attempt to delete the item in the keychain
        let status = SecItemDelete(keychainQuery as CFDictionary)
        try parseKeychainStatus(status)
    }
    
    // MARK: - Private helpers
    
    /// Updates an existing value stored in the keychain.
    private static func update(valueData: Data, keyData: Data) throws {
        let keychainQuery = keychainQuery(with: keyData)
        // set the attribute we want to update (the value)
        let attributes: [String: Any] = [
            kSecValueData as String: valueData
        ]
        
        // attempt to update the item in the keychain
        let status = SecItemUpdate(keychainQuery as CFDictionary, attributes as CFDictionary)
        try parseKeychainStatus(status)
    }
    
    /// Creates a base keychain query using the key's data representation.
    private static func keychainQuery(with keyData: Data) -> [String: Any] {
        [
            // specify the class of keychain item to be a generic password item
            kSecClass as String: kSecClassGenericPassword,
            // we will use the 'account' attribute as the key when reading/writing the keychain
            // Data is toll-free bridged to CFData
            kSecAttrAccount as String: keyData
        ]
    }
    
    /// Converts the key `String` to UTF-8 `Data` or throws an error.
    private static func keyData(from key: String) throws -> Data {
        guard let keyData = key.data(using: .utf8) else { throw SecuredStorageError.keyNotUTF8Representable }
        return keyData
    }

    /// Converts the value `String` to UTF-8 `Data` or throws an error.
    private static func valueData(from value: String) throws -> Data {
        guard let valueData = value.data(using: .utf8) else { throw SecuredStorageError.valueNotUTF8Representable }
        return valueData
    }
    
    /// Parses a Keychain transaction result status into a more informative error type.
    private static func parseKeychainStatus(_ status: OSStatus) throws {
        switch status {
        case errSecSuccess:
            // transaction succeeded
            return
        case errSecItemNotFound:
            // item for key does not exist in keychain
            throw SecuredStorageError.valueNotFoundForKey
        case errSecDuplicateItem:
            // the item already exists in the keychain, we need to
            // update rather than write
            throw SecuredStorageError.keyAlreadyExists
        default:
            // some other error throw
            throw SecuredStorageError.keychainError(status: status)
        }
    }
}
