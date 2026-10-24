//
//  InformationCard.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import SwiftUI

struct InformationDashboardCard: View {
    
    let totalSum: Double
    let firstSmallCardInformation: String
    let secondSmallCardInformation: String
    let cardType: SegmentedDashboard
    let cardPeriod: DashboardPeriod
    let isMaintence: Bool = false
    
    private var cardTotalTitle: String {
        switch cardType {
        case .profits:
            switch cardPeriod {
            case .oneMonth: String(localized: "Lucro Total Mensal")
            case .sixMonths: String(localized: "Lucro Total Semestral")
            case .oneYear: String(localized: "Lucro Total Anual")
            }
        case .expenses:
            switch cardPeriod {
            case .oneMonth: String(localized: "Despesa Total Mensal")
            case .sixMonths: String(localized: "Despesa Total Semestral")
            case .oneYear: String(localized: "Despesa Total Anual")
            }
        }
    }
    
    private var isProfit: Bool { cardType == .profits }
    
    var body: some View {
        Grid {
            GridRow {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "dollarsign")
                            .foregroundStyle(isProfit ? .profit : .redProfit)
                            .font(.subheadline.bold())
                        
                        Text(cardTotalTitle)
                            .foregroundStyle(.secondary)
                            .font(.footnote.bold())
                    }
                    
                    Text(isProfit ? totalSum : -totalSum, format: .currency(code: "BRL"))
                        .font(.largeTitle.bold())
                        .foregroundStyle(isProfit ? .profit : .redProfit)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .gridCellColumns(2)
            
            Divider()
                .frame(width: 380)
                .background(.secondary)
            
            GridRow {
                HStack {
                    smallInfo(
                        icon: isProfit ? "dollarsign.arrow.trianglehead.counterclockwise.rotate.90" : "wrench.and.screwdriver",
                        title: isProfit ? "Aluguéis Recebidos" : "Manutenção",
                        value: firstSmallCardInformation,
                        iconColor: isProfit ? .profit : .redProfit,
                        valueColor: .primary
                    )
                    
                    Divider()
                        .frame(height: 100)
                        .background(.secondary)
                    
                    smallInfo(
                        icon: isProfit ? "clock" : "ellipsis.circle.badge",
                        title: isProfit ? "Aluguéis Pendentes" : "Outras despesas",
                        value: secondSmallCardInformation,
                        iconColor: .redProfit,
                        valueColor: isProfit ? .redProfit : .primary
                    )
                }
            }
            .gridCellColumns(2)
        }
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 34))
    }
    
    @ViewBuilder
    private func smallInfo(icon: String, title: LocalizedStringKey, value: String, iconColor: Color, valueColor: Color) -> some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(iconColor)
                    .font(.subheadline.bold())
                
                Text(title)
                    .foregroundStyle(.secondary)
                    .font(.footnote.bold())
            }
            
            Text(value)
                .font(.title.bold())
                .foregroundStyle(valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    InformationDashboardCard(totalSum: 2700, firstSmallCardInformation: "R$ 700,00", secondSmallCardInformation: "R$ 2.000,00", cardType: .expenses, cardPeriod: .oneMonth)
}
