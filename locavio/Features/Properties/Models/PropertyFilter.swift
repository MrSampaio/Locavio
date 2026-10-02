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
    
    var id: Self { self }
}
