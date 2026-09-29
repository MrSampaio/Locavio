//
//  UserModel.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    
    // para usar o cloudkit, todos os campos precisam ser opcionais
    var appleUserID: String = ""
    var fullName: String?
    var email: String?
    var documentType: DocumentTypeModel?
    var documentNumber: String?
    var properties: [Property]?
    
    
    
    init(appleUserID: String, fullName: String? = nil, email: String? = nil, documentType: DocumentTypeModel? = nil, documentNumber: String? = nil) {
        self.appleUserID = appleUserID
        self.fullName = fullName
        self.email = email
        self.documentType = documentType
        self.documentNumber = documentNumber
    }
}
