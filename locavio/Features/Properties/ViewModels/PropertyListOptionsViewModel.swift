//
//  PropertyListOptionsViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 29/09/26.
//

import Foundation
import Observation

enum PropertySortOption: String, CaseIterable, Identifiable {
    case price = "Por preço"
    case alphabetical = "Ordem alfabética"
    case oldest = "Mais antigos"
    case newest = "Mais recentes"

    var id: Self { self }
}

enum RentFilter: String, CaseIterable, Identifiable {
    case all = "Todos"
    case paid = "Pago"
    case pending = "Pendente"

    var id: Self { self }
}

@Observable
final class PropertyListOptionsViewModel {
    var sort: PropertySortOption = .price
    var typeFilter: PropertyType? = nil
    var rentFilter: RentFilter = .all

    var hasActiveFilters: Bool {
        typeFilter != nil || rentFilter != .all
    }

   
    func apply(to properties: [Property], search: String = "") -> [Property] {
        properties
            .enumerated()
            .map { (position: $0.offset, property: $0.element) }
            .filter { matchesFilters($0.property) && matchesSearch($0.property, search) }
            .sorted { areInOrder($0, $1) }
            .map(\.property)
    }



    private func matchesFilters(_ property: Property) -> Bool {
        if let typeFilter, property.type != typeFilter { return false }

        switch rentFilter {
        case .all:     return true
        case .paid:    return property.isPaid == true
        case .pending: return property.isPaid != true
        }
    }

    private func matchesSearch(_ property: Property, _ text: String) -> Bool {
        let query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }

        return [property.title, property.street, property.neighborhood, property.city]
            .compactMap { $0 }
            .contains { $0.localizedStandardContains(query) }
    }

 
    private typealias Item = (position: Int, property: Property)

    private func areInOrder(_ a: Item, _ b: Item) -> Bool {
        switch sort {
        case .price:
           
            return (a.property.profit ?? -.infinity) > (b.property.profit ?? -.infinity)
        case .alphabetical:
            return (a.property.title ?? "")
                .localizedStandardCompare(b.property.title ?? "") == .orderedAscending
        case .oldest:
            return a.position < b.position
        case .newest:
            return a.position > b.position
        }
    }
}
