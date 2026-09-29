//
//  ListCardComponent.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 29/09/26.
//

import SwiftUI

struct ListCardComponent: View {
    
    let textList: String
    
    var body: some View {
        VStack {
            Text(textList)
                .font(.caption2)
        }
        .padding(10)
        .background(.listCard, in: RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.listStrokeCard)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    
    let textList = """
        • Nome e sobrenome
        • E-mail
        • Endereço, Estado, Província, CEP, Cidade
        • Dados dos imóveis cadastrados (endereço, características, fotos)
        • Dados de contratos de locação e valores de aluguel
        • Solicitações de manutenção e histórico de comunicação sobre os imóveis
        • Dados de calendário/agenda relacionados aos imóveis
        • Documentos e fotos que você anexar ao Aplicativo (ex.: contratos, comprovantes)
        """
    
    ListCardComponent(textList: textList)
}
