//
//  Errors.swift
//  locavio
//
//  Created by Julio Sampaio on 02/10/26.
//

import Foundation

enum PropertiesErrors: LocalizedError {
    case invalidTitle
    case invalidArea
    case invalidNumber
    case invalidProfit
    case invalidOwner
    
    var errorDescription: String? {
        switch self {
        case .invalidTitle:
            return String(localized: "Insira um título válido.")
        case .invalidArea:
            return String(localized: "Insira uma área válida.")
        case .invalidNumber:
            return String(localized: "Insira um número válido.")
        case .invalidProfit:
            return String(localized: "Insira um lucro válido.")
        case .invalidOwner:
            return String(localized: "Problema na autenticação. Entre em contato com o administrador do sistema")
        }
    }
}

enum TenantErrors: LocalizedError {
    case invalidName
    case invalidCpf
    case invalidPhone
    
    var errorDescription: String? {
        switch self {
            case .invalidName:
                return String(localized: "Insira um nome válido.")
            case .invalidCpf:
                return String(localized: "Insira um CPF válido.")
            case .invalidPhone:
                return String(localized: "Insira um telefone válido.")
        }
    }
}

enum ExpensesErrors: LocalizedError {
    case invalidValue
    
    var errorDescription: String? {
        switch self {
            case .invalidValue: return String(localized: "Insira um valor numérico válido na despesa.")
        }
    }
}
