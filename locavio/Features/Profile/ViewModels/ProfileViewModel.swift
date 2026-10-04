//
//  ProfileViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftUI

@Observable
final class ProfileViewModel{
    
    var notifyPayments: Bool = true
    var notifyPendentPayments: Bool = true
    var notifyTickets: Bool = true
    
    var showLogoutAlert: Bool = false
    
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
}
