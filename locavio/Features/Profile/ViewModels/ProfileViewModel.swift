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
    var showDeleteErrorAlert: Bool = false
    
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
        // pega o ID antes de apagar, porque depois o objeto deixa de existir
        let userID = user.appleUserID
        
        do {
            // apaga o Owner (o cascade apaga TUDO relacionado a ele), salva, limpa o Keychain
            // e muda o estado do app para .loggedOut. se falhar, nada é limpo e o usuário é avisado
            try authManager.deleteLocalAccount(userID: userID, context: context)
            
            // ATENÇÃO (App Store, diretriz 5.1.1(v)): quem usa Sign in with Apple precisa revogar o token
            // da Apple ao excluir a conta. isso só é possível a partir de um servidor (a chave .p8 não pode
            // ficar no app) chamando https://appleid.apple.com/auth/revoke. sem servidor, a alternativa
            // documentada na TN3194 é orientar o usuário a revogar o acesso em Ajustes (ver texto do alerta)
            
        } catch {
            print("Error when trying to delete user: \(error.localizedDescription)")
            showDeleteErrorAlert = true
        }
    }
}
