//
//  PropertyFilter.swift
//  locavio
//
//  Created by Julio Sampaio on 02/10/26.
//

import Foundation

enum PropertyFilter: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case alugados = "Alugados"
    case naoAlugados = "Não Alugados"
    
    var displayTitle: String {
        switch self {
        case .todos: return String(localized: "Todos")
        case .alugados: return String(localized: "Alugados")
        case .naoAlugados: return String(localized: "Não Alugados")
        }
    }

    var id: Self { self }
}
