//
//  FaceIdLoginManager.swift
//  Teebay
//
//  Created by Ikram Khan Johan on 30/6/25.
//

import UIKit
import LocalAuthentication

final class FaceIdLoginManager {
    
    static let shared = FaceIdLoginManager()
    
    private init() {}
    
    private let accountKey = "user_credentials"
    private let serviceKey = "DON.teebay"
    
    
    func saveCredentialsToKeychain(email: String, password: String) -> Bool {
        let credentialsData = "\(email):\(password)".data(using: .utf8)!

        let access = SecAccessControlCreateWithFlags(nil,
                                                     kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                     .biometryCurrentSet,
                                                     nil)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accountKey,
            kSecAttrService as String: serviceKey,
            kSecValueData as String: credentialsData,
            kSecAttrAccessControl as String: access,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationUI
        ]

        // Delete if already exists
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func deleteCredentialsFromKeychain() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accountKey,
            kSecAttrService as String: serviceKey
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
    
    func retrieveCredentialsWithFaceID(completion: @escaping (String?, String?) -> Void) {
        let context = LAContext()
        context.localizedReason = "Authenticate to login with Face ID"

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accountKey,
            kSecAttrService as String: serviceKey,
            kSecReturnData as String: true,
            kSecUseOperationPrompt as String: "Login using Face ID"
        ]

        var dataTypeRef: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess,
           let data = dataTypeRef as? Data,
           let credentialString = String(data: data, encoding: .utf8) {
            let components = credentialString.split(separator: ":", maxSplits: 1)
            if components.count == 2 {
                let email = String(components[0])
                let password = String(components[1])
                completion(email, password)
                return
            }
        }
        completion(nil, nil)
    }
    
    func areCredentialsStored() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accountKey,
            kSecAttrService as String: serviceKey,
            kSecReturnData as String: false, // Don't return data
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationUI // Don't show Face ID prompt
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)

        return status == errSecSuccess
    }

}
