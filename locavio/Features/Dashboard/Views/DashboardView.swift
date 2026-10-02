//
//  DashboardView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

enum DashboardPeriod: String, CaseIterable, Identifiable {
    case oneMonth = "1 mês"
    case sixMonths = "6 meses"
    case oneYear = "1 ano"
    
    var id: Self { self }
}

enum SegmentedDashboard: String, CaseIterable, Identifiable {
    case profits = "Lucro"
    case expenses = "Despesa"
    
    var id: Self { self }
}

struct DashboardView: View {
    
    @State private var currentFilter: SegmentedDashboard = .profits
    
    var body: some View {
        ZStack {
            Color.appBg
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Picker("Filtro", selection: $currentFilter) {
                    ForEach(SegmentedDashboard.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                
                InformationDashboardCard(totalSum: 150000, firstSmallCardInformation: 7, secondSmallCardInformation: 2, cardType: currentFilter)
            }
            .padding()
            
            
        }
    }
}

#Preview {
    DashboardView()
}
