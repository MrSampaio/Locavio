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
//    var isRented: Bool?
    var area: Int?
    var paymentDay: Int?
    var isPaid: Bool?
    var cep: String?
    var street: String?
    var neighborhood: Int?
    var number: Int?
    var city: String?
    var uf: String?
//    var expenses: [Expenses]
    var profit: Double?
//    var tenant: Tenant?
//    var contract: Contract
    
    init(image: Data? = nil, title: String? = nil, type: PropertyType? = .other, area: Int? = nil, paymentDay: Int? = nil, isPaid: Bool? = nil, cep: String? = nil, street: String? = nil, neighborhood: Int? = nil, number: Int? = nil, city: String? = nil, uf: String? = nil, profit: Double? = nil) {
        
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
        
    }
}
