//
//  InformationCard.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 01/10/26.
//

import SwiftUI

struct InformationDashboardCard: View {
    
    let totalSum: Double
    let firstSmallCardInformation: Int
    let secondSmallCardInformation: Int
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
            
            if (cardType == .profits) {
                Divider()
                    .frame(width: 380)
                    .background(.secondary)
                
                GridRow {
                    HStack {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                                    .foregroundStyle(cardType == .profits ? .profit : .redProfit)
                                    .font(.subheadline.bold())
                                
                                Text("Aluguéis Recebidos")
                                    .foregroundStyle(.secondary)
                                    .font(.footnote.bold())
                            }
                            
                            Text(String(firstSmallCardInformation))
                                .font(.largeTitle.bold())
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
                            
                            Text(String(secondSmallCardInformation))
                                .font(.largeTitle.bold())
                                .foregroundStyle(.redProfit)
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity)
                    }
                }
                .gridCellColumns(2)
            }
        }
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 34))
    }
}

#Preview {
    InformationDashboardCard(totalSum: 2700, firstSmallCardInformation: 700, secondSmallCardInformation: 2000, cardType: .profits)
}
