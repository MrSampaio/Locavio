//
//  ProfileViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class ProfileViewModel{
    
    var notifyPayments: Bool = true
    var notifyPendentPayments: Bool = true
    var notifyTickets: Bool = true
    
    var showLogoutAlert: Bool = false
    var showDeleteAccountAlert: Bool = false
    
    // função que mascara o documento para não ser completamente exibido na tela de perfil
    func maskDocument(_ document: String) -> String {
        let numbers = document.filter { $0.isNumber }
        
        // máscara de CPF
        if numbers.count == 11 {
            
            let start = numbers.prefix(3)
            let end = numbers.suffix(2)
            return "•••.\(start).•••-\(end)"
            
        // máscara de CNPJ
        } else if numbers.count == 14 {
            
            let start = numbers.prefix(2)
            let end = numbers.suffix(2)
            return "••.•••.•••/••••-\(end)"
            
        }
        return "Documento Inválido"
    }
    
    // função de contagem de inquilinos
    func calculateActiveTenants(from properties: [Property]?) -> Int {
        guard let properties = properties else { return 0 }
        
        // filtra os imóveis que têm um inquilino e conta quantos são
        return properties.filter { $0.tenant != nil }.count
    }
    
    // função de contagem de propriedades
    func calculateTotalProperties(from properties: [Property]?) -> Int {
        guard let properties = properties else { return 0 }
        return properties.count
    }
    
    // função para deletar perfil do usuário
    func deleteAccount(user: Owner, context: ModelContext, authManager: AppleAuthManager) {
        do {
            // deleta o usuário. o cascade irá apagar TUDO relacionado a ele.
            context.delete(user)
            
            // força o salvamento para garantir que os dados sumam do CloudKit/Banco local na hora
            try context.save()
            
            // limpa as credenciais do Keychain e muda o estado do app para .loggedOut
            authManager.logout()
            
        } catch {
            print("Error when trying to delete user: \(error.localizedDescription)")
        }
    }
}
