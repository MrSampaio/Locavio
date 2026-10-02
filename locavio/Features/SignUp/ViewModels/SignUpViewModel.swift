//
//  SignUpViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class SignUpViewModel {
    var selectedDocumentType: DocumentTypeModel = .pf
    var documentNumber: String = ""
    
    // variável computada que verifica em tempo real se o documento é válido
    var isValid: Bool {
        if selectedDocumentType == .pf {
            return documentNumber.isValidCPF
        } else {
            return documentNumber.isValidCNPJ
        }
    }
    
    // variável computada que contém mensagem de erro
    var errorMessage: String? {
        let justNumbers = documentNumber.filter { $0.isNumber }
        let expectedLength = selectedDocumentType == .pf ? 11 : 14
        
        // se já digitou todos os números e a matemática falhou, joga erro
        if justNumbers.count >= expectedLength && !isValid {
            return "Documento inválido."
        }
        
        // retorna nulo se o documento for válido ou se ele ainda tiver digitando
        return nil
    }
    
    func saveDocument(document: String, documentType: DocumentTypeModel, context: ModelContext, authManager: AppleAuthManager) {
        
        guard let userID = KeychainHelper.shared.readString(for: "appleUserID") else {
            print("Error: User ID not found in Keychain Storage.")
            return
        }
        
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        do {
            if let user = try context.fetch(descriptor).first {
                
                // atualiza o usuário existente no banco com o documento e tipo
                user.documentNumber = document
                user.documentType = documentType
                
                // força o salvamento no banco local
                try context.save()
                
                // muda o estado global para que o app redirecione para a MainTabView
                DispatchQueue.main.async {
                    authManager.currentAuthState = .authenticated
                }
                
            } else {
                print("Error: User not found in database to add document")
            }
        } catch {
            print("Error when trying to fetch/save user into database: \(error)")
        }
    }
    
    
    
    // função que injeta a pontuação em tempo real baseada no Enum
    func applyDocumentMask(to text: String) -> String {
        let numbers = Array(text.filter { $0.isNumber })
        var result = ""
        var index = 0
        
        let mask = selectedDocumentType == .pf ? "###.###.###-##" : "##.###.###/####-##"
        
        for char in mask {
            // se os números acabaram, interrompe o loop
            if index >= numbers.count { break }
            
            if char == "#" {
                result.append(numbers[index])
                index += 1
            } else {
                result.append(char)
            }
        }
        
        return result
    }
    
    
    
    
    
    // função que verifica os documentos - ela puxa as extensões de String que validam CPF ou CNPJ e retorna um bool
//    func validateDocument() -> Bool{
//        if selectedDocumentType == .pf {
//            return documentNumber.isValidCPF
//        } else {
//            let justNumbers = documentNumber.filter { $0.isNumber }
//            return justNumbers.count == 14
//        }
//    }
}
