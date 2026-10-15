//
//  LoginViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 19/09/26.
//

import Foundation
import SwiftData

@Observable
final class LoginViewModel {
    
    // cria ou atualiza o Owner no SwiftData e decide pra qual tela o app vai
    @MainActor
    func syncUserToSwiftData(info: AppleSignInInfo, context: ModelContext, authManager: AppleAuthManager) async {
        
        let userID = info.userID
        
        // mostra a tela de carregamento enquanto procura a conta.
        // depois de reinstalar, o banco local está vazio e a conta pode estar chegando do iCloud
        authManager.currentAuthState = .loading
        
        // busca o Owner (juntando duplicados, sem apagar imóveis) e espera o iCloud se precisar
        let existingOwner = await authManager.waitForOwner(userID: userID, context: context)
        
        do {
            if let owner = existingOwner {
                
                // a Apple só manda nome e email na primeira autorização.
                // então só preenche se estiver faltando e NUNCA sobrescreve um dado existente com nil
                if (owner.fullName ?? "").isEmpty, let name = info.fullName {
                    owner.fullName = name
                }
                if (owner.email ?? "").isEmpty, let email = info.email {
                    owner.email = email
                }
                
                try context.save()
                
                // decide pra qual tela vai baseado no documento
                if let doc = owner.documentNumber, !doc.isEmpty {
                    authManager.currentAuthState = .authenticated
                } else {
                    authManager.currentAuthState = .needsRegistration
                }
                
            } else {
                
                // não achou nem no banco local nem no iCloud: usuário novo (ou conta excluída).
                // cria o perfil com o que a Apple mandou e pede o cadastro (documento).
                //
                // IMPORTANTE: nunca marcar como .authenticated sem documento. o Owner sem documento
                // faz o app voltar pro cadastro no próximo login
                let newOwner = Owner(appleUserID: userID, fullName: info.fullName, email: info.email)
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
