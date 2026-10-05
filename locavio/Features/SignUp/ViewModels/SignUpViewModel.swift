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
    
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    // variável computada que verifica em tempo real se o documento é válido
    var isValid: Bool {
        if selectedDocumentType == .pf {
            return DocumentAuth
                .isValidDocument(document: documentNumber, type: .pf)
        } else {
            return DocumentAuth
                .isValidDocument(document: documentNumber, type: .pj)
        }
    }
    
    func saveDocument(document: String, documentType: DocumentTypeModel, context: ModelContext, authManager: AppleAuthManager) {
        
        guard let userID = KeychainHelper.shared.readString(for: "appleUserID") else {
            alertMessage = "Erro de autenticação. Por favor, faça login novamente."
            showAlert = true
            print("Error: User ID not found in Keychain Storage.")
            return
        }
        
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        do {
            if let user = try context.fetch(descriptor).first {
                
                user.documentNumber = document
                user.documentType = documentType
                user.fullName = KeychainHelper.shared.readString(for: "appleUserFullName")
                print("Nome completo depois do cadastro: ", KeychainHelper.shared.readString(for: "appleUserFullName"))
                user.email = KeychainHelper.shared
                    .readString(for: "appleUserEmail")
                
                try context.save()
                
                DispatchQueue.main.async {
                    authManager.currentAuthState = .authenticated
                }
                
            } else {
                alertMessage = "Usuário não encontrado no banco de dados. Tente novamente."
                showAlert = true
                print("Error: User not found in database to add document")
            }
        } catch {
            alertMessage = "Ocorreu um erro inesperado ao salvar seus dados. Tente novamente."
            showAlert = true
            print("Error when trying to fetch/save user into database: \(error.localizedDescription)")
        }
    }
    
    func maskDocument(text: String, type: DocumentTypeModel) -> String{
        return DocumentAuth.applyDocumentMask(to: text, documentType: type)
    }
    
}
