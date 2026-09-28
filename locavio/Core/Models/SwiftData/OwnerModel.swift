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
    var email: String?
    var name: String?
    var phone: String?
    var documentType: DocumentTypeModel?
    var property: [Property]?
    var notifyPayments: Bool?
    var notifyDueDate: Bool?
    var notifyTickets: Bool?
    
    init(email: String? = nil, name: String? = nil, phone: String? = nil, documentType: DocumentTypeModel? = .pf, properties: [Property]? = nil, notifyPayments: Bool? = nil, notifyDueDate: Bool? = nil, notifyTickets: Bool? = nil) {
        self.email = email
        self.name = name
        self.phone = phone
        self.documentType = documentType
        self.property = property
        self.notifyPayments = notifyPayments
        self.notifyDueDate = notifyDueDate
        self.notifyTickets = notifyTickets
    }
}
