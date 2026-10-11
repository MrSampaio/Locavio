//
//  PropertiesViewModel+drafts.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 10/10/26.
//

import Foundation

extension PropertiesViewModel {

    /// Caminho inverso do `setValueToPropertyDraft`: lê do draft o valor atual de um campo.
    func draftValue(for type: PropertyFieldType) -> String {
        switch type {
        case .name:         return propertyDraft.name
        case .area:         return propertyDraft.area
        case .cep:          return propertyDraft.cep
        case .street:       return propertyDraft.street
        case .number:       return propertyDraft.number
        case .neighborhood: return propertyDraft.neighborhood
        case .city:         return propertyDraft.city
        case .federalUnit:  return propertyDraft.federalUnit
        case .complement:   return propertyDraft.complement
        case .profit:       return propertyDraft.profit
        case .payday:       return propertyDraft.payday
        case .tenantName:   return propertyDraft.tenantName
        case .tenantEmail:  return propertyDraft.tenantEmail
        case .tenantCPF:    return propertyDraft.tenantCPF
        case .tenantPhone:  return propertyDraft.tenantPhone
        }
    }
}
