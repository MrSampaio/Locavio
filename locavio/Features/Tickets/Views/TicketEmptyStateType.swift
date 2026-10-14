//
//  TicketEmptyStateType.swift
//  locavio
//
//  Created by Julio Sampaio on 13/10/26.
//

import SwiftUI

enum TicketEmptyStateType {
    case noProperties
    case noTickets
    case searchEmpty
}

struct TicketsEmptyStateView: View {
    
    var stateType: TicketEmptyStateType
    var onAction: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 16) {
            
            // icone dinâmico
            Image(systemName: iconName)
                .font(.system(size: 76))
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
            
            // título dinâmico
            Text(titleText)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // subtítulo dinâmico
            Text(subtitleText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            // botão aparece apenas quando não é uma busca vazia
            if stateType != .searchEmpty {
                ComponentButton(
                    textButton: buttonText,
                    action: onAction
                )
                .frame(width: 210)
                .padding(.top, 24)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBg)
    }
    
    // MARK: - Propriedades Dinâmicas
    
    private var iconName: String {
        switch stateType {
        case .noProperties: return "house.slash"
        case .noTickets: return "wrench.and.screwdriver"
        case .searchEmpty: return "magnifyingglass"
        }
    }
    
    private var titleText: String {
        switch stateType {
        case .noProperties: return "Nenhum imóvel cadastrado"
        case .noTickets: return "Nenhum chamado aberto"
        case .searchEmpty: return "Nenhum chamado encontrado"
        }
    }
    
    private var subtitleText: String {
        switch stateType {
        case .noProperties: return "Você precisa de um imóvel para\npoder criar um chamado."
        case .noTickets: return "Crie seu primeiro chamado de manutenção\npara começar a acompanhar os reparos."
        case .searchEmpty: return "Tente buscar por outro nome ou mudar\no filtro atual."
        }
    }
    
    private var buttonText: String {
        switch stateType {
        case .noProperties: return "Ir para Imóveis"
        case .noTickets: return "Adicionar chamado"
        case .searchEmpty: return ""
        }
    }
}

#Preview("Sem Imóveis") {
    TicketsEmptyStateView(stateType: .noProperties)
}

#Preview("Sem Chamados") {
    TicketsEmptyStateView(stateType: .noTickets)
}

#Preview("Busca Vazia") {
    TicketsEmptyStateView(stateType: .searchEmpty)
}
