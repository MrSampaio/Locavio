//
//  ScreenPropertyModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import Foundation
import SwiftData

enum PropertyType: String, Codable, CaseIterable, Identifiable{
    case home = "Casa"
    case apartment = "Apartamento"
    case kitnet = "Kitnet"
    case store = "Loja"
    case loft = "Loft"
    case warehouse = "Galpão"
    case studio = "Studio"
    case other = "Outro"
    
    var id: Self { self }
}

@Model
final class Property: Identifiable {
    var image: Data?
    var title: String?
    var type: PropertyType?
    var area: Int?
    var paymentDay: Int?
    var cep: String?
    var street: String?
    var neighborhood: String?
    var number: String?
    var city: String?
    var uf: String?
    var complement: String?
    var profit: Double?
    var owner: Owner?
    
    @Relationship(deleteRule: .cascade, inverse: \Expenses.property)
    var expenses: [Expenses]?
    
    @Relationship(deleteRule: .cascade, inverse: \Tenant.property)
    var tenant: Tenant?
    
    @Relationship(deleteRule: .cascade, inverse: \Contract.property)
    var contract: Contract?
    
    @Relationship(deleteRule: .cascade, inverse: \Payment.property)
    var payments: [Payment]?
    
    // se excluir o imóvel, apaga os chamados junto
    @Relationship(deleteRule: .cascade, inverse: \Ticket.property)
    var tickets: [Ticket]?
    
    var isPaid: Bool {
        !(payments(inMonthOf: .now, calendar: .current)).isEmpty
    }

    
    init(image: Data? = nil, title: String? = nil, type: PropertyType? = nil, area: Int? = nil, paymentDay: Int? = nil, cep: String? = nil, street: String? = nil, neighborhood: String? = nil, number: String? = nil, city: String? = nil, uf: String? = nil, complement: String? = nil, profit: Double? = nil, owner: Owner? = nil, expenses: [Expenses]? = nil, tenant: Tenant? = nil, contract: Contract? = nil, payments: [Payment]? = nil, tickets: [Ticket]? = nil) {
        self.image = image
        self.title = title
        self.type = type
        self.area = area
        self.paymentDay = paymentDay
        self.cep = cep
        self.street = street
        self.neighborhood = neighborhood
        self.number = number
        self.city = city
        self.uf = uf
        self.complement = complement
        self.profit = profit
        self.owner = owner
        self.expenses = expenses
        self.tenant = tenant
        self.contract = contract
        self.payments = payments
        self.tickets = tickets
    }
}
