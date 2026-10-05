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
    
    // a Apple só envia o nome na primeira autorização.
    // se o Owner não tiver nome (ex.: conta excluída e criada de novo), a tela pede o nome ao usuário
    var fullName: String = ""
    var needsFullName: Bool = false
    
    var showAlert: Bool = false
    var alertMessage: String = ""
    
    // variável computada que verifica em tempo real se o formulário é válido
    var isValid: Bool {
        let documentIsValid = DocumentAuth.isValidDocument(document: documentNumber, type: selectedDocumentType)
        let nameIsValid = !needsFullName || !trimmedFullName.isEmpty
        
        return documentIsValid && nameIsValid
    }
    
    private var trimmedFullName: String {
        fullName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // descobre se o Owner já tem nome. se não tiver, a tela mostra o campo de nome
    func loadOwner(context: ModelContext, authManager: AppleAuthManager) {
        guard let userID = authManager.currentUserID else { return }
        
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        let owner = try? context.fetch(descriptor).first
        
        let existingName = owner?.fullName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        needsFullName = existingName.isEmpty
    }
    
    func saveDocument(document: String, documentType: DocumentTypeModel, context: ModelContext, authManager: AppleAuthManager) {
        
        guard let userID = authManager.currentUserID else {
            alertMessage = "Erro de autenticação. Por favor, faça login novamente."
            showAlert = true
            print("Error: User ID not found in Keychain Storage.")
            return
        }
        
        if needsFullName && trimmedFullName.isEmpty {
            alertMessage = "Informe seu nome para continuar."
            showAlert = true
            return
        }
        
        let descriptor = FetchDescriptor<Owner>(predicate: #Predicate { $0.appleUserID == userID })
        
        do {
            // busca o Owner criado no login. se por algum motivo não existir, cria agora
            // (em vez de travar o cadastro com "usuário não encontrado")
            let owner: Owner
            if let existing = try context.fetch(descriptor).first {
                owner = existing
            } else {
                owner = Owner(appleUserID: userID)
                context.insert(owner)
            }
            
            owner.documentNumber = document
            owner.documentType = documentType
            
            // só grava o nome se o usuário digitou. nunca apaga um nome que já existe
            if !trimmedFullName.isEmpty {
                owner.fullName = trimmedFullName
            }
            
            try context.save()
            
            authManager.currentAuthState = .authenticated
            
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
