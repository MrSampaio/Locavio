//
//  PropertiesEmptyStateView.swift
//  locavio
//
//  Created by Julio Sampaio on 13/10/26.
//

import SwiftUI

struct PropertiesEmptyStateView: View {
    
    var isSearchFilterEmpty: Bool
    var onAddProperty: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            
            // ícone dinâmico
            Image(systemName: isSearchFilterEmpty ? "magnifyingglass" : "building.2")
                .font(.system(size: 76))
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
            
            // título dinâmico
            Text(isSearchFilterEmpty ? "Nenhum imóvel encontrado" : "Nenhum imóvel cadastrado")
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // subtítulo dinâmico
            Text(isSearchFilterEmpty
                 ? "Tente buscar por outro nome ou mudar\no filtro atual."
                 : "Adicione seu primeiro imóvel para\ncomeçar a gerenciar.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            // botão aparece apenas quando não é uma busca vazia
            if !isSearchFilterEmpty {
                ComponentButton(
                    textButton: "Adicionar imóvel",
                    action: onAddProperty
                )
                .frame(width: 196)
                .padding(.top, 24)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBg)
    }
}

#Preview("Sem Imóveis (Novo usuário)") {
    PropertiesEmptyStateView(isSearchFilterEmpty: false)
}

#Preview("Busca Vazia (Filtro não encontrou)") {
    PropertiesEmptyStateView(isSearchFilterEmpty: true)
}
