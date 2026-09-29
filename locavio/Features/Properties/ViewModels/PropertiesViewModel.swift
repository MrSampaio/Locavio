//
//  PropertiesViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import Observation

enum PropertyFilter: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case alugados = "Alugados"
    case naoAlugados = "Não Alugados"

    var id: Self { self }
}

@Observable
final class PropertiesViewModel {
    var searchText = ""
    var filter: PropertyFilter = .todos

    
    let options = PropertyListOptionsViewModel()

  
    func visibleProperties(from properties: [Property]) -> [Property] {
        let bySegment = properties.filter(matchesSegment)
        return options.apply(to: bySegment, search: searchText)
    }


    private func matchesSegment(_ property: Property) -> Bool {
        switch filter {
        case .todos:       return true
        case .alugados:    return property.tenant != nil
        case .naoAlugados: return property.tenant == nil
        }
    }

    func addProperty() { print("Adicionar") }
}


