//
//  ToolbarComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 27/09/26.
//
import SwiftUI

struct AppToolbar: ToolbarContent {
    @Bindable var options: PropertyListOptionsViewModel
    var onAdd: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Section("Ordenar por") {
                    Picker("Ordenar por", selection: $options.sort) {
                        ForEach(PropertySortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.inline)
                }

                Section("Filtrar por") {
                    Menu("Tipo de imóvel") {
                        Picker("Tipo de imóvel", selection: $options.typeFilter) {
                            Text("Todos").tag(PropertyType?.none)
                            ForEach(PropertyType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(PropertyType?.some(type))
                            }
                        }
                        .pickerStyle(.inline)
                    }

                    Menu("Aluguel") {
                        Picker("Aluguel", selection: $options.rentFilter) {
                            ForEach(RentFilter.allCases) { filter in
                                Text(filter.rawValue).tag(filter)
                            }
                        }
                        .pickerStyle(.inline)
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }

        ToolbarSpacer(.fixed, placement: .topBarTrailing)

        ToolbarItem(placement: .topBarTrailing) {
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            }
            .buttonStyle(.glassProminent)
            .tint(.accentColor)
        }
    }
}

#Preview {
    let options = PropertyListOptionsViewModel()

    NavigationStack {
        Color.clear
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                AppToolbar(
                    options: options,
                    onAdd: { print("Adicionar") }
                )
            }
    }
}
