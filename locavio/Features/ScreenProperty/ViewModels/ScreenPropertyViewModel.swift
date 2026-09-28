//
//  ScreenPropertyViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import SwiftUI
import Combine

enum PropertyFilter: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case alugados = "Alugados"
    case naoAlugados = "Não Alugados"

    var id: Self { self }
}

final class ScreenPropertyViewModel: ObservableObject {
    @Published var properties: [Property] = []
    @Published var searchText = ""
    @Published var filter: PropertyFilter = .todos

    var filteredProperties: [Property] {
        properties
//            .filter { property in
//                switch filter {
//                case .todos: return true
//                case .alugados: return property.isRented
//                case .naoAlugados: return !property.isRented
//                }
//            }
//            .filter { property in
//                searchText.isEmpty ||
//                property.title.localizedCaseInsensitiveContains(searchText) ||
//                property.address.localizedCaseInsensitiveContains(searchText)
//            }
    }

    func showOptions() { print("Opções") }
    func addProperty() { print("Adicionar") }
}
