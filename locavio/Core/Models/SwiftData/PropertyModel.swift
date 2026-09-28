//
//  ScreenPropertyModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import Foundation
import SwiftData

enum PropertyType: String, Codable{
    case home = "Casa"
    case apartment = "Apartamento"
    case kitnet = "Kitnet"
    case store = "Loja"
    case loft = "Loft"
    case warehouse = "Galpão"
    case studio = "Studio"
    case other = "Outro"
}

@Model
final class Property: Identifiable {
    var image: Data?
    var title: String?
    var type: PropertyType?
    var area: Int?
    var paymentDay: Int?
    var isPaid: Bool?
    var cep: String?
    var street: String?
    var neighborhood: String?
    var number: Int?
    var city: String?
    var uf: String?
    var profit: Double?
    
    @Relationship(deleteRule: .cascade, inverse: \Expenses.property)
    var expenses: [Expenses]?
    
    @Relationship(deleteRule: .cascade, inverse: \Tenant.property)
    var tenant: Tenant?
    
    @Relationship(deleteRule: .cascade, inverse: \Contract.property)
    var contract: Contract?
    
    @Relationship(deleteRule: .cascade, inverse: \Owner.property)
    var owner: Owner?
    
    init(image: Data? = nil, title: String? = nil, type: PropertyType? = nil, area: Int? = nil, paymentDay: Int? = nil, isPaid: Bool? = nil, cep: String? = nil, street: String? = nil, neighborhood: String? = nil, number: Int? = nil, city: String? = nil, uf: String? = nil, profit: Double? = nil, expenses: [Expenses]? = nil, tenant: Tenant? = nil, contract: Contract? = nil) {
        self.image = image
        self.title = title
        self.type = type
        self.area = area
        self.paymentDay = paymentDay
        self.isPaid = isPaid
        self.cep = cep
        self.street = street
        self.neighborhood = neighborhood
        self.number = number
        self.city = city
        self.uf = uf
        self.profit = profit
        self.expenses = expenses
        self.tenant = tenant
        self.contract = contract
    }
}
