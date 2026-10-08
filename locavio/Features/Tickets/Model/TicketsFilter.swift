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
    case noRented = "Concluídos"
    
    var id: Self { self }
}
