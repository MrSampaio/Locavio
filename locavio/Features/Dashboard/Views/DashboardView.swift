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

struct DashboardView: View {
    var body: some View {
        Text("Tela de Dashboard")
    }
}

#Preview {
    DashboardView()
}
