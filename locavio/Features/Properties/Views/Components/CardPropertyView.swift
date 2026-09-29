//
//  PropertyCardView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

import SwiftUI

struct PropertyCardView: View {
    let viewModel: PropertyCardViewModel
    @Environment(\.colorScheme) private var colorScheme

    init(property: Property) {
        self.viewModel = PropertyCardViewModel(property: property)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            background
            infoPanel
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
    }

   

    @ViewBuilder
    private var background: some View {
        if let uiImage = viewModel.image {
            Color.clear
                .overlay {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                }
                .clipped()
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

  

    private var infoPanel: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(viewModel.title)
                    .font(.title.bold())
                    .lineLimit(1)

                Text(viewModel.address)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                    .lineLimit(1)
                    .truncationMode(.tail)

                tenantLine
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: 6) {
                Text(viewModel.rentLabel)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)

                Text(viewModel.rentText)
                    .font(.title2.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                VStack(alignment: .trailing, spacing: 0) {
                    Text(viewModel.nextPaymentLabel)
                    Text(viewModel.nextPaymentText).fontWeight(.semibold)
                }
                .font(.footnote)
                .foregroundStyle(secondaryTextColor)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .foregroundStyle(primaryTextColor)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background { panelBackground }
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
        .foregroundStyle(primaryTextColor.opacity(0.75))
        .lineLimit(1)
    }

    

    private var panelShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 32, style: .continuous)
    }

  
    @ViewBuilder
    private var panelBackground: some View {
        if viewModel.hasImage {
            panelShape.fill(.ultraThinMaterial)
        } else if colorScheme == .dark {
            panelShape.fill(Color.white)
        } else {
            panelShape
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .overlay {
                    LinearGradient(colors: [.black.opacity(0.25), .black.opacity(0.6)],
                                   startPoint: .top, endPoint: .bottom)
                        .clipShape(panelShape)
                }
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

#Preview("Sem imagem - light") {
    PropertyCardView(property: Property(
        title: "Casa 1", paymentDay: 10, street: "Rua Ipê dsdsd", number: 55,
        city: "São Paulo", profit: 1200
    ))
    .padding()
}

#Preview("Sem imagem - dark") {
    PropertyCardView(property: Property(
        title: "Casa 1", paymentDay: 10, street: "Rua Ipê Amarelo", number: 55,
        city: "São Paulo", profit: 1200
    ))
    .padding()
    .preferredColorScheme(.dark)
}



private func previewPropertyWithImage() -> Property {
    Property(
        image: UIImage(named: "CasaText")?.jpegData(compressionQuality: 0.9),
        title: "Casa 1", paymentDay: 10, street: "Rua Ipê Amarelo", number: 55,
        city: "São Paulo", profit: 1200
    )
}

#Preview("Com imagem - light") {
    PropertyCardView(property: previewPropertyWithImage())
        .padding()
}

#Preview("Com imagem - dark") {
    PropertyCardView(property: previewPropertyWithImage())
        .padding()
        .preferredColorScheme(.dark)
}
 



