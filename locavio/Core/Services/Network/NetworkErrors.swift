//
//  NetworkErrors.swift
//  locavio
//
//  Created by Julio Sampaio on 06/10/26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case notFound
    case decodingError
    
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return String(localized: "CEP inválido. Verifique se o CEP contém apenas números e 8 dígitos.")
            case .invalidResponse:
                return String(localized: "Resposta inválida. Verifique a sua conexão de internet.")
            case .notFound:
                return String(localized: "CEP não encontrado. Verifique se o CEP é válido.")
            case .decodingError:
                return String(localized: "Erro de decodificação. Tente novamente mais tarde.")
        }
    }
}
