//
//  PropertyDraft.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 06/10/26.
//

import Foundation

enum PropertyFieldType {
    case name
    case area
    case cep
    case street
    case number
    case neighborhood
    case city
    case federalUnit
    case complement
    case profit
    case payday
    case tenantName
    case tenantEmail
    case tenantCPF
    case tenantPhone
    
    var id: Self { self }
}

struct PropertyDraft {
    var image: Data? = nil
    var name = ""
    var area = ""
    var cep = ""
    var street = ""
    var number = ""
    var neighborhood = ""
    var city = ""
    var federalUnit = ""
    var complement = ""
    var profit = ""
    var payday = ""
    var tenantName = ""
    var tenantEmail = ""
    var tenantCPF = ""
    var tenantPhone = ""
}
