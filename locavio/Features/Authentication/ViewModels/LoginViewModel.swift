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
    
    // cria ou atualiza o Owner no SwiftData e decide pra qual tela o app vai
    func syncUserToSwiftData(info: AppleSignInInfo, context: ModelContext, authManager: AppleAuthManager) {
        
        let userID = info.userID
        
        // verifica se o usuário já existe no banco local
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        do {
            if let owner = try context.fetch(descriptor).first {
                
                // a Apple só manda nome e email na primeira autorização.
                // então só preenche se estiver faltando e NUNCA sobrescreve um dado existente com nil
                if (owner.fullName ?? "").isEmpty, let name = info.fullName {
                    owner.fullName = name
                }
                if (owner.email ?? "").isEmpty, let email = info.email {
                    owner.email = email
                }
                
                if let doc = owner.documentNumber, !doc.isEmpty {
                    authManager.currentAuthState = .authenticated
                } else {
                    authManager.currentAuthState = .needsRegistration
                }
                
            } else {
                
                // usuário novo (ou conta que foi excluída): cria o perfil com o que a Apple mandou.
                // se o nome vier nil, a tela de cadastro pede o nome
                let newOwner = Owner(appleUserID: userID, fullName: info.fullName, email: info.email)
                
                // insere no SwiftData (o iCloud vai sincronizar automaticamente hehe)
                context.insert(newOwner)
                try context.save()
                
                authManager.currentAuthState = .needsRegistration
            }
            
        } catch {
            print("Error when trying to fetch user from SwiftData: \(error)")
            
            // sem o Owner não dá pra seguir. encerra a sessão pra não ficar com um ID salvo e sem dados
            authManager.logout()
        }
    }
}
