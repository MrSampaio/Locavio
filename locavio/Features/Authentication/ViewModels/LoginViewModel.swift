//
//  LoginViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import Foundation
import SwiftData

@Observable
final class LoginViewModel{
    
    func syncUserToSwiftData(context: ModelContext, authManager: AppleAuthManager) {
        
        // puxa o ID salvo no Keychain Storage
        guard let userID = KeychainHelper.shared.readString(for: "appleUserID") else { return }
        
        // verifica se o usuário já existe no banco local
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        do {
            let existingUsers = try context.fetch(descriptor)
            
            
            if let user = existingUsers.first {
                
                if let doc = user.documentNumber, !doc.isEmpty {
                    authManager.currentAuthState = .authenticated
                } else {
                    authManager.currentAuthState = .needsRegistration
                }
                
            } else {
                
                // caso seja um usuário novo no dispositivo, cria suas infos puxando do Keychain
                let name = KeychainHelper.shared.readString(for: "appleUserFullName")
                let email = KeychainHelper.shared.readString(for: "appleUserEmail")
                
                // atribui as infos do novo perfil
                
                let newUserProfile = Owner(appleUserID: userID, fullName: name, email: email)
                
                // insere no SwiftData (o iCloud vai sincronizar automaticamente hehe)
                context.insert(newUserProfile)
                
                authManager.currentAuthState = .needsRegistration
                
                // var newUser = verifyNewUser(context: context)
                
            }
           
        } catch {
            print("Error when trying to fetch user from SwiftData: \(error)")
        }
    }
}

        
       
