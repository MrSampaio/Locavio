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
            if let owners = try? context.fetch(descriptor), !owners.isEmpty {
                // ordena para que o perfil que tem o documento preenchido fique em primeiro lugar
                let sortedOwners = owners.sorted { ($0.documentNumber?.isEmpty == false) && ($1.documentNumber?.isEmpty ?? true) }
                
                // o usuário principal é o primeiro da lista ordenada
                let mainOwner = sortedOwners.first!
                
                // se o iCloud baixou o antigo e ficou um novo sobrando, apaga o(s) extra(s)
                if sortedOwners.count > 1 {
                    for extraOwner in sortedOwners.dropFirst() {
                        context.delete(extraOwner)
                    }
                    try? context.save()
                }
                
                // a Apple só manda nome e email na primeira autorização.
                // então só preenche se estiver faltando e NUNCA sobrescreve um dado existente com nil
                if (mainOwner.fullName ?? "").isEmpty, let name = info.fullName {
                    mainOwner.fullName = name
                }
                if (mainOwner.email ?? "").isEmpty, let email = info.email {
                    mainOwner.email = email
                }
                
                // decide pra qual tela vai baseado no documento
                if let doc = mainOwner.documentNumber, !doc.isEmpty {
                    authManager.currentAuthState = .authenticated
                } else {
                    authManager.currentAuthState = .needsRegistration
                }
                
            } else {
                // usuário NÃO encontrado localmente.
                
                // se a Apple não mandou o nome, é porque o usuário já usou o app antes!
                // ou seja, é uma reinstalação.
                let isReinstall = (info.fullName == nil)
                
                let newOwner = Owner(appleUserID: userID, fullName: info.fullName, email: info.email)
                context.insert(newOwner)
                try context.save()
                
                if isReinstall {
                    // sendo uma reinstalação, sabemos que o iCloud vai descarregar os dados
                    // dele (incluindo o documento e os imóveis) nos próximos segundos
                    // Em vez de forçar um novo registo, deixa entrar no app.
                    authManager.currentAuthState = .authenticated
                } else {
                    // A Apple mandou o nome? Então é realmente a primeira vez
                    authManager.currentAuthState = .needsRegistration
                }
            }
            
        } catch {
            print("Error when trying to fetch user from SwiftData: \(error)")
            // sem o Owner não dá pra seguir. encerra a sessão pra não ficar com um ID salvo e sem dados
            authManager.logout()
        }
    }
}
