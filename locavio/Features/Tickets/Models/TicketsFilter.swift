//
//  TicketsModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 08/10/26.
//

import Foundation

enum TicketsFilter: String, CaseIterable, Identifiable {
    case all = "Todos"
    case open = "Abertos"
    case closed = "Concluídos"
    
    var displayTitle: String {
        switch self {
        case .all: return String(localized: "Todos")
        case .open: return String(localized: "Abertos")
        case .closed: return String(localized: "Concluídos")
        }
    }

    var id: Self { self }
}
