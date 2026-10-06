//
//  DashboardWithNoProperty.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 06/10/26.
//

import SwiftUI


struct DashboardWithNoPropertyView:View {
    var body: some View {
        VStack{
            Image(systemName: "house.slash")
                .font(.system(size: 76))
                .foregroundStyle(.secondary)
            
            Text("Você ainda não tem imóveis")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("Cadastre seu primeiro imóvel para começar a\n gerenciar seus lucros e despesas no Relatório")
                .font(.subheadline)
                .fontWeight(.regular)
            
            
            
            ComponentButton(
                textButton: "Adicionar imóvel",
                action: {}
            )
            .frame(width: 196)
            .padding(.top, 40)
            
        
        }
    }
}

#Preview {
    DashboardWithNoPropertyView()
}
