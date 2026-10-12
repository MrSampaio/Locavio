//
//  TenantModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData

@Model
final class Tenant: Identifiable {
    var name: String?
    var email: String?
    var cpf: String?
    var phone: String?
    var property: Property?
    
    init(name: String? = nil, email: String? = nil, cpf: String? = nil, phone: String? = nil, property: Property? = nil) {
        self.name = name
        self.email = email
        self.cpf = cpf
        self.phone = phone
        self.property = property
    }
}
