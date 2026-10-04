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
    
    var errorDescription: String? {
        switch self {
            case .invalidTitle:
                return "Insira um título válido."
            case .invalidArea:
                return "Insira uma área válida."
            case .invalidNumber:
                return "Insira um número válido."
            case .invalidProfit:
                return "Insira um lucro válido."
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
                return "Insira um nome válido."
            case .invalidCpf:
                return "Insira um CPF válido."
            case .invalidPhone:
                return "Insira um telefone válido."
        }
    }
}

enum ExpensesErrors: LocalizedError {
    case invalidTitle
    case invalidValue
    
    var errorDescription: String? {
        switch self {
            case .invalidTitle: return "Insira um título válido para a despesa."
            case .invalidValue: return "Insira um valor numérico válido na despesa."
        }
    }
}
