//
//  Keychain.swift
//  skeleton
//
//  Created by Eric Dobyns
//  Copyright © 2015 Eric Dobyns. All rights reserved.
//

import Foundation
import Security

class Keychain {
    
    func set(key: String, value: String) {
        if let data: NSData = value.data(using: String.Encoding.utf8) as NSData? {
            setData(key: key, value: data)
        }
    }
    
    func setData(key: String, value: NSData) {
        let query = [
            (kSecClass as String)       : kSecClassGenericPassword,
            (kSecAttrAccount as String) : key,
            (kSecValueData as String)   : value
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        SecItemAdd(query as CFDictionary, nil)
    }

    func get(key: String) -> NSString? {
        if let data = getData(key: key) {
            return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        }
        
        return nil
    }
    
    func getData(key: String) -> NSData? {
        let query = [
            (kSecClass as String)       : kSecClassGenericPassword,
            (kSecAttrAccount as String) : key,
            (kSecReturnData as String)  : kCFBooleanTrue,
            (kSecMatchLimit as String)  : kSecMatchLimitOne
        ] as [String : Any]

        var retrievedData: NSData?
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &extractedData)
        
        if (status == errSecSuccess) {
            retrievedData = extractedData as? NSData
        }
        
        if status == noErr && retrievedData != nil {
            return retrievedData
        }
        
        return nil
    }
    
    func delete(key: String) {
        let query = [
            (kSecClass as String)       : kSecClassGenericPassword,
            (kSecAttrAccount as String) : key
        ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func clear() {
        let query = [
            (kSecClass as String): kSecClassGenericPassword
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}






