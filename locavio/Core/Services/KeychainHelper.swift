//
//  KeychainHelper.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import Foundation
import Security

final class KeychainHelper: Sendable{
    
    // shared pra facilitar o acesso ao Keychain
    static let shared = KeychainHelper()

    private init() {}

    // bundle identifier pra evitar conflitos
    private let service = Bundle.main.bundleIdentifier ?? "com.locavio.login"
    
    // função de salvar
    func save(_ data: Data, for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]

        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]

        let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

        if updateStatus == errSecItemNotFound {
            var newItem = query
            newItem[kSecValueData as String] = data

            let addStatus = SecItemAdd(newItem as CFDictionary, nil)
            if addStatus != errSecSuccess {
                print("Error when trying to add into keychain: \(addStatus)")
            }
        } else if updateStatus != errSecSuccess {
            print("Error when trying to update data into keychain: \(updateStatus)")
        }
    }
    
    // função para ler o valores do keychain
    func read(for key: String) -> Data? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kCFBooleanTrue!,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    // função para deletar os valores do keychain
    func delete(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kCFBooleanTrue!
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound{
            print("Keychain delete failed \(status)")
        }
    }
    
    // funções de conveniência
    func save(_ value: String, for key: String){
        guard let data = value.data(using: .utf8) else { return }
        save(data, for: key)
    }
    
    func readString(for key: String) -> String? {
        guard let data = read(for: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
