//
//  DashboardView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    
    @Environment(DashboardViewModel.self) private var dashboardViewModel
    @Query private var properties: [Property]
    
    var body: some View {
        
        @Bindable var dashboardViewModelBind = dashboardViewModel
        
        ZStack {
            Color.appBg
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Picker("Filtro", selection: $dashboardViewModelBind.currentFilter.animation(.easeInOut)) {
                    ForEach(SegmentedDashboard.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                
                InformationDashboardCard(totalSum: dashboardViewModel.totalSum, firstSmallCardInformation: dashboardViewModel.countReceivedRent(), secondSmallCardInformation: dashboardViewModel.countNotReceivedRent(), cardType: dashboardViewModel.currentFilter)
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    Text(dashboardViewModel.chartTitle)
                        .font(.subheadline.bold())
                        .foregroundStyle(.secondary)
                    
                    Chart(dashboardViewModel.monthlyChartData) { data in
                        BarMark(
                            x: .value("Mês", data.month, unit: .month),
                            y: .value("Valor", data.total),
                        )
                        .foregroundStyle(dashboardViewModel.currentFilter == .profits ? .profit : .redProfit)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 18,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 18
                            )
                        )
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .month)) { value in
                            AxisValueLabel(centered: true) {
                                if let date = value.as(Date.self) {
                                    Text(shortMonth(date))
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 34))
            }
            .padding()
        }
        .onAppear {
            dashboardViewModel.properties = properties
        }
    }
    
    private func shortMonth(_ date: Date) -> String {
        date.formatted(.dateTime.month(.abbreviated).locale(Locale(identifier: "pt_BR")))
            .replacingOccurrences(of: ".", with: "")
            .capitalized
    }
}

#Preview {
    
    let container = try! ModelContainer(for: Property.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    func daysAgo(_ days: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: -days, to: .now)
    }
    
    let property = Property()
    
    let payments = [
        Payment(date: daysAgo(3), property: property, value: 1200),
        Payment(date: daysAgo(5), property: property, value: 3000),
        Payment(date: daysAgo(10), property: property, value: 2500),
        Payment(date: daysAgo(20), property: property, value: 4100)
    ]
    
    let expenses = [
        Expenses(property: property, value: 250, date: daysAgo(3)),
        Expenses(property: property, value: 500, date: daysAgo(5)),
        Expenses(property: property, value: 1200, date: daysAgo(10)),
        Expenses(property: property, value: 920, date: daysAgo(20)),
    ]
    
    property.payments = payments
    property.expenses = expenses
    
    let property2 = Property()
    
    let payments2 = [
        Payment(date: daysAgo(3), property: property, value: 1200),
        Payment(date: daysAgo(5), property: property, value: 3000),
        Payment(date: daysAgo(50), property: property, value: 2500),
        Payment(date: daysAgo(50), property: property, value: 4100)
    ]
    
    let expenses2 = [
        Expenses(property: property, value: 250, date: daysAgo(3)),
        Expenses(property: property, value: 500, date: daysAgo(5)),
        Expenses(property: property, value: 1200, date: daysAgo(10)),
        Expenses(property: property, value: 920, date: daysAgo(20)),
    ]
    
    property2.payments = payments2
    property2.expenses = expenses2
    property2.isPaid = true
    
    container.mainContext.insert(property)
    container.mainContext.insert(property2)
    
    return DashboardView()
        .environment(DashboardViewModel())
        .modelContainer(container)
}
