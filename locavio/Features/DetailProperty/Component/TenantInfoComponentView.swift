//
//  TenantInfoComponentView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 30/09/26.
//

import SwiftUI


struct TenantSectionView: View {
    let viewModel: PropertyDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text(viewModel.tenantSectionTitle)
                .font(.title3.bold())
            tenantCard
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    
    private var tenantCard: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            if viewModel.hasTenant {
                if let name = viewModel.tenantName {
                    Text(name)
                        .font(.title3)
                        .foregroundStyle(.primary)
                }
                
                if let email = viewModel.tenantEmail {
                    Text(email)
                        .foregroundStyle(.secondary)
                }
                
                if let cpf = viewModel.tenantCPF {
                    Text(cpf)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(viewModel.noTenantText)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .lineLimit(1)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
    
}

#Preview("Com inquilino") {
    let tenant = Tenant(name: "Alberto Caseiro",
                        email: "bertinhocaeiro@fpessoa.com",
                        cpf: "12345678901")
    let property = Property(title: "Casa 1", tenant: tenant)
    
    TenantSectionView(viewModel: PropertyDetailViewModel(property: property))
        .padding()
}

#Preview("Sem inquilino") {
    let property = Property(title: "Casa 1")
    
    TenantSectionView(viewModel: PropertyDetailViewModel(property: property))
        .padding()
        .preferredColorScheme(.dark)
}
