//
//  MainTabView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI
import SwiftData

enum AppTab: Hashable {
    case properties, dashboard, calendar, tickets, profile
}

struct MainTabView: View {
    
    @Query private var properties: [Property]
    @Query private var tickets: [Ticket]
    @Query private var owners: [Owner]
    @Environment(AppleAuthManager.self) private var authManager
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var selectedTab: AppTab = .properties
    
    private var currentOwner: Owner? {
        guard let userID = authManager.currentUserID else { return nil }
        return owners.first { $0.appleUserID == userID }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab("Imóveis", systemImage: "house", value: .properties) {
                PropertiesCoordinatorView()
            }
            
            Tab("Relatório", systemImage: "chart.bar", value: .dashboard) {
                DashboardCoordinatorView()
            }
            
            Tab("Calendário", systemImage: "calendar", value: .calendar) {
                CalendarCoordinatorView()
            }
            
            Tab("Chamados", systemImage: "exclamationmark.bubble", value: .tickets) {
                TicketsCoordinatorView(onSwitchToProperties: {
                    selectedTab = .properties
                })
            }
            
            Tab("Perfil", systemImage: "person", value: .profile) {
                ProfileCoordinatorView()
            }
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
            syncNotifications()
        }
        .onChange(of: properties) { _, _ in syncNotifications() }
        .onChange(of: tickets) { _, _ in syncNotifications() }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                syncNotifications()
            }
        }
    }
    
    private func syncNotifications() {
        NotificationManager.shared.syncNotifications(
            properties: properties,
            tickets: tickets,
            owner: currentOwner
        )
    }
}
