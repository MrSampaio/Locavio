//
//  KeychainHelper.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import Foundation
import Security

// chaves usadas no Keychain.
// SÓ o ID do usuário fica guardado ali (é o "ponteiro" da sessão).
// nome e email pertencem ao Owner no SwiftData e são apagados junto com a conta.
enum KeychainKey {
    static let appleUserID = "appleUserID"
    
    // chaves de versões antigas do app, que guardavam nome e email no Keychain.
    // só existem aqui para serem limpas no logout
    static let legacyFullName = "appleUserFullName"
    static let legacyEmail = "appleUserEmail"
}

final class KeychainHelper: Sendable {
    
    // shared pra facilitar o acesso ao Keychain
    static let shared = KeychainHelper()
    
    private init() {}
    
    // bundle identifier pra evitar conflitos
    private let service = Bundle.main.bundleIdentifier ?? "com.locavio.login"
    
    // consulta base. o kSecAttrSynchronizableAny faz a busca, a atualização e a remoção
    // funcionarem tanto para itens novos quanto para os antigos, que foram salvos como sincronizáveis
    private func baseQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
        ]
    }
    
    // função de salvar
    func save(_ data: Data, for key: String) {
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]
        
        let updateStatus = SecItemUpdate(
            baseQuery(for: key) as CFDictionary,
            attributesToUpdate as CFDictionary
        )
        
        switch updateStatus {
            case errSecSuccess:
                break
                
            case errSecItemNotFound:
                var newItem = baseQuery(for: key)
                
                // fica só neste aparelho: não sobe para o iCloud Keychain nem vai para outros dispositivos
                newItem[kSecAttrSynchronizable as String] = false
                newItem[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
                newItem[kSecValueData as String] = data
                
                let addStatus = SecItemAdd(newItem as CFDictionary, nil)
                if addStatus != errSecSuccess {
                    print("Error when trying to add into keychain: \(addStatus)")
                }
                
            default:
                print("Error when trying to update data into keychain: \(updateStatus)")
        }
    }
    
    // função para ler o valores do keychain
    func read(for key: String) -> Data? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    // função para deletar os valores do keychain
    func delete(for key: String) {
        let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            print("Keychain delete failed \(status)")
        }
    }
    
    // funções de conveniência
    func save(_ value: String, for key: String) {
        guard let data = value.data(using: .utf8) else { return }
        save(data, for: key)
    }
    
    func readString(for key: String) -> String? {
        guard let data = read(for: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
