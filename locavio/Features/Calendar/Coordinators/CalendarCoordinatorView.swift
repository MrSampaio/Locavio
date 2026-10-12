//
//  CalendarCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

struct CalendarCoordinatorView: View {
    @State private var calendarCoordinator = CalendarCoordinator()
        
    var body: some View {
        NavigationStack(path: $calendarCoordinator.path) {
            CalendarView()
                .environment(calendarCoordinator)
                .navigationDestination(for: CalendarRoutes.self) { route in
                    switch route {
                        case .ticketDetails(let ticket):
                            TicketDetailView(
                                ticket: ticket,
                                editAction: {
                                    calendarCoordinator.pushToEditTicket(ticket: ticket)
                                }
                                
                            )
                        case .editTicket(let ticket):
                            // 👇 Lida com a abertura da tela de edição
                            EditTicketView(ticket: ticket)
                    }
                }
        }
    }
}
