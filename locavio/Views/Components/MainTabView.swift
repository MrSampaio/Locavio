//
//  MainTabView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PropertiesCoordinatorView()
                .tabItem {
                    Label("Imóveis", systemImage: "house")
                }
            DashboardView()
                .tabItem{
                    Label("Relatório", systemImage: "chart.bar")
                }
            
            CalendarView()
                .tabItem{
                    Label("Calendário", systemImage: "calendar")
                }
            
            TicketsView()
                .tabItem{
                    Label("Chamados", systemImage: "exclamationmark.bubble")
                }
        }
    }
}
