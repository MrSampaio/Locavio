//
//  OwnerModel.swift
//  locavio
//
//  Created by Julio Sampaio on 28/09/26.
//

import Foundation
import SwiftData


@Model
final class Owner: Identifiable {
    
    var appleUserID: String = ""
    var fullName: String?
    var email: String?
    var documentType: DocumentTypeModel?
    var documentNumber: String?
    var phone: String?
    var notifyPayments: Bool?
    var notifyDueDate: Bool?
    var notifyTickets: Bool?
    
    @Relationship(deleteRule: .cascade, inverse: \Property.owner)
    var properties: [Property]?
    
    
    init(appleUserID: String, fullName: String? = nil, email: String? = nil, documentType: DocumentTypeModel? = nil, documentNumber: String? = nil, phone: String? = nil, notifyPayments: Bool? = nil, notifyDueDate: Bool? = nil, notifyTickets: Bool? = nil, properties: [Property]? = nil) {
        self.appleUserID = appleUserID
        self.fullName = fullName
        self.email = email
        self.documentType = documentType
        self.documentNumber = documentNumber
        self.phone = phone
        self.notifyPayments = notifyPayments
        self.notifyDueDate = notifyDueDate
        self.notifyTickets = notifyTickets
        self.properties = properties
    }
}
