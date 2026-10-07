//
//  EditProfileViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 04/10/26.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class EditProfileViewModel{
    var userImageData: Data? = nil
    
    var fullName: String = ""
    var selectedDocumentType: DocumentTypeModel = .pf
    var documentNumber: String = ""
    
    
    var showErrorAlert: Bool = false
    var errorMessage = ""
    

    
    // função para carregar os dados do usuário com o objeto que vem  na sheet
    func loadUserData(user: Owner){
        userImageData = user.profilePicture
        
        #warning("tratar exibição para mostrar apenas o primeiro e ultimo nome do usuário e avisar enquanto ele estiver preenchendo o nome completo")
        fullName = user.fullName ?? ""

        selectedDocumentType = user.documentType ?? .pf
        documentNumber = user.documentNumber ?? ""
    }
    
    
    // função para salvar os dados do usuário
    func saveUserData(context: ModelContext, user: Owner) -> Bool{
        
        guard DocumentAuth.isValidDocument(document: documentNumber, type: selectedDocumentType) else {
            errorMessage = "O documento informado é inválido."
            showErrorAlert = true
            return false
        }
        
        var trimmedFullName: String {
            fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        user.profilePicture = userImageData
        
        user.documentType = selectedDocumentType
        user.documentNumber = documentNumber
        
        user.fullName = trimmedFullName
        
        
        do {
            try context.save()
            return true
            
        } catch {
            errorMessage = "Não foi possível salvar as alterações. Verifique os dados e tente novamente."
            showErrorAlert = true
            
            print("Error when trying to save data from EditProfileView: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func maskDocument(text: String, type: DocumentTypeModel) -> String{
        return DocumentAuth.applyDocumentMask(to: text, documentType: type)
    }
}
