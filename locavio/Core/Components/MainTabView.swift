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
            Tab("Imóveis", systemImage: "house"){
                PropertiesCoordinatorView()
            }
            
            Tab("Relatório", systemImage: "chart.bar") {
                DashboardCoordinatorView()
            }
            
            Tab("Calendário", systemImage: "calendar"){
                CalendarCoordinatorView()
            }
            
            Tab("Chamados", systemImage: "exclamationmark.bubble"){
                TicketsCoordinatorView()
            }
            
            Tab("Perfil", systemImage: "person"){
                ProfileCoordinatorView()
            }
            
//            DashboardCoordinatorView()
//                .tabItem{
//                    Label("Relatório", systemImage: "chart.bar")
//                }
//            
//            CalendarCoordinatorView()
//                .tabItem{
//                    Label("Calendário", systemImage: "calendar")
//                }
//            
//            TicketsCoordinatorView()
//                .tabItem{
//                    Label("Chamados", systemImage: "exclamationmark.bubble")
//                }
        }
        
        
    }
}
