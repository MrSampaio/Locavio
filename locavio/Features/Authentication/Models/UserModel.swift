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
    
    init(appleUserID: String, fullName: String? = nil, email: String? = nil) {
        self.appleUserID = appleUserID
        self.fullName = fullName
        self.email = email
    }
}
