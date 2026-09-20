//
//  PropertiesViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI
import SwiftData

@Observable
final class PropertiesViewModel {
    
    var userName: String = "Carregando..."
    var userEmail: String = "Carregando..."
    
    // função de fetch para pegar os dados do usuário pelo keychain
    // recebe o contexto como parâmetro, já que ele só pode ser passado em structs
    func fetchUserData(context: ModelContext) {
        
        // pega o id do usuário cadastrado no keychain
        guard let userID = KeychainHelper.shared.readString(for: "appleUserID") else {
            self.userName = "No user found"
            return
        }
        
        // procura no SwiftData o perfil que tem esse id
        let descriptor = FetchDescriptor<UserProfile>(predicate: #Predicate { $0.appleUserID == userID })
        
        do {
            let existingUsers = try context.fetch(descriptor)
            
            if let userProfile = existingUsers.first {
                // caso tenha achado o perfil no banco, atualiza as variáveis
                self.userName = userProfile.fullName ?? "Usuário"
                self.userEmail = userProfile.email ?? "Sem email cadastrado"
            } else {
                // caso não tenha encontrado ou caso o icloud demore pra responder
                self.userName = "No user found"
            }
        } catch {
            print("Error when trying to fetch user from SwiftData: \(error)")
        }
    }
}
