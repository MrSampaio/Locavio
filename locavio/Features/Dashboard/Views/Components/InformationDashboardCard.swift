//
//  InformationCard.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import SwiftUI

struct InformationDashboardCard: View {
    
    let totalSum: Double
    let firstSmallCardInformation: Double
    let secondSmallCardInformation: Double
    let cardType: SegmentedDashboard
    
    var body: some View {
        Grid {
            GridRow {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "dollarsign")
                            .foregroundStyle(cardType == .profits ? .profit : .redProfit)
                            .font(.subheadline.bold())
                        
                        Text(cardType == .profits ? "Lucro Total" : "Despesas Totais")
                            .foregroundStyle(.secondary)
                            .font(.footnote.bold())
                    }
                    
                    Text(cardType == .profits ? totalSum : -totalSum, format: .currency(code: "BRL"))
                        .font(.largeTitle.bold())
                        .foregroundStyle(cardType == .profits ? .profit : .redProfit)
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
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: cardType == .profits ? "dollarsign.arrow.trianglehead.counterclockwise.rotate.90" : "wrench.and.screwdriver.fill")
                                .foregroundStyle(cardType == .profits ? .profit : .redProfit)
                                .font(.subheadline.bold())
                            
                            Text(cardType == .profits ? "Aluguéis Recebidos" : "Manutenção")
                                .foregroundStyle(.secondary)
                                .font(.footnote.bold())
                        }
                        
                        smallCardValue(firstSmallCardInformation)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                        .frame(height: 100)
                        .background(.secondary)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: cardType == .profits ? "clock" : "ellipsis.circle.badge")
                                .foregroundStyle(.redProfit)
                                .font(.subheadline.bold())
                            
                            Text(cardType == .profits ? "Aluguéis Pendentes" : "Outras despesas")
                                .foregroundStyle(.secondary)
                                .font(.footnote.bold())
                        }
                        
                        smallCardValue(secondSmallCardInformation, pendingRent: cardType == .profits ? true : false)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                }
            }
            .gridCellColumns(2)
        }
        .frame(maxWidth: .infinity, maxHeight: 240)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 34))
    }
    
    @ViewBuilder
    private func smallCardValue(_ value: Double, pendingRent: Bool = false) -> some View {
        if cardType == .profits {
            Text(value, format: .number.precision(.fractionLength(0)))
                .font(.largeTitle.bold())
                .foregroundStyle(pendingRent ? .redProfit : .primary)
        } else {
            Text(value, format: .currency(code: "BRL"))
                .font(.title2.bold())
        }
    }
}

#Preview {
    InformationDashboardCard(totalSum: 2700, firstSmallCardInformation: 700, secondSmallCardInformation: 2000, cardType: .profits)
}
