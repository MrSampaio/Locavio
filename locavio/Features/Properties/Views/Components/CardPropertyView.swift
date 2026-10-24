//
//  PropertyCardView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import SwiftUI

struct PropertyCardView: View {
    let viewModel: PropertyCardViewModel
    let expensesViewModel: ExpensesViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var textColor: Color = .white
    
    init(property: Property) {
        self.viewModel = PropertyCardViewModel(property: property)
        self.expensesViewModel = ExpensesViewModel(property: property)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            background
            infoPanel
        }
        .frame(maxWidth: .infinity)
        .frame(height: 330)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .task(id: viewModel.image) {
            if let image = viewModel.image {
                // Só a faixa inferior, onde o texto está
                let region = CGRect(x: 0, y: 0.7, width: 1, height: 0.3)
                
                let luminance = await Task.detached(priority: .userInitiated) {
                    await image.averageLuminance(in: region)
                }.value
                
                if let luminance {
                    textColor = luminance > 0.55 ? .black : .white
                }
            }
        }
    }
    
    // Fundo
    
    @ViewBuilder
    private var background: some View {
        if let uiImage = viewModel.image {
            Color.clear
                .overlay {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .allowsHitTesting(false)
                }
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        } else {
            Color(.systemGray4)
                .overlay(alignment: .top) {
                    Image(systemName: "photo")
                        .font(.system(size: 56))
                        .foregroundStyle(Color(.systemGray))
                        .padding(.top, 50)
                }
        }
    }
    
    // Painel
    
    private var infoPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.title)
                        .foregroundStyle(textColor)
                        .font(.title.bold())
                        .lineLimit(1)
                    
                    Text(viewModel.address)
                        .font(.subheadline)
                        .foregroundStyle(textColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    tenantLine
                        .foregroundStyle(textColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(viewModel.rentLabel)
                        .font(.subheadline)
                        .foregroundStyle(textColor)
                    
                    Text(expensesViewModel.totalRentValue, format: .currency(code: "BRL"))
                        .font(.title2.bold())
                        .foregroundStyle(textColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    VStack(alignment: .trailing, spacing: 0) {
                        Text(viewModel.nextPaymentLabel)
                        Text(viewModel.nextPaymentText).fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .foregroundStyle(textColor)
                }
                .fixedSize(horizontal: true, vertical: false)
            }
            
            badgesRow
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background { panelBackground }
    }
    
    
    
    private var badgesRow: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.badges) { badge in
                TagBadgeView(badge)
            }
        }
    }
    
    
    
    @ViewBuilder
    private var tenantLine: some View {
        Group {
            if let name = viewModel.tenantName {
                Text("\(Text("Locatário:").bold()) \(name)")
            } else {
                Text(viewModel.noTenantText)
            }
        }
        .font(.subheadline)
        
        .lineLimit(1)
    }
    
    // Estilo do painel
    
    private var panelShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 32, style: .continuous)
    }
    
    @ViewBuilder
    private var panelBackground: some View {
        if viewModel.hasImage {
            panelShape.fill(.ultraThinMaterial)
        } else {
            panelShape
                .fill(.quaternary)
        }
    }
    
    private var primaryTextColor: Color {
        if viewModel.hasImage { return .primary }
        return colorScheme == .dark ? .black : .white
    }
    
    private var secondaryTextColor: Color {
        if viewModel.hasImage { return .secondary }
        return colorScheme == .dark ? .black.opacity(0.6) : .white.opacity(0.6)
    }
}


#Preview("Sem imagem") {
    PropertyCardView(property: Property(
        title: "Casa 1", type: .home, area: 32, paymentDay: 10,
        street: "Rua Ipê Amarelo", number: "55", city: "São Paulo", profit: 1200
    ))
    .padding()
}

private func previewPropertyWithImage() -> Property {
    Property(
        image: UIImage(named: "CasaText")?.jpegData(compressionQuality: 0.9),
        title: "Casa 1", type: .home, area: 32, paymentDay: 10,
        street: "Rua Ipê Amarelo", number: "55", city: "São Paulo", profit: 1200
    )
}

#Preview("Com imagem") {
    PropertyCardView(property: previewPropertyWithImage())
        .padding()
}






