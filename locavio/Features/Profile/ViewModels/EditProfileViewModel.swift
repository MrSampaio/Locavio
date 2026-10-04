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
    
    var selectedDocumentType: DocumentTypeModel = .pf
    var documentNumber: String = ""
    
    // função para carregar os dados do usuário com o objeto que vem  na sheet
    func loadUserData(user: Owner){
        userImageData = user.profilePicture
    
        selectedDocumentType = user.documentType ?? .pf
        documentNumber = user.documentNumber ?? ""
    }
    
    // função para salvar os dados do usuário
    func saveUserData(user: Owner) throws{
        user.profilePicture = userImageData
        
        user.documentType = selectedDocumentType
        user.documentNumber = documentNumber
    }
}
