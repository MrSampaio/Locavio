//
//  TicketsCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import SwiftUI

struct TicketsCoordinatorView: View {
    @State private var ticketsCoordinator = TicketsCoordinator()
        
    var body: some View {
        NavigationStack(path: $ticketsCoordinator.path) {
            TicketsView()
                .environment(ticketsCoordinator)
                .navigationDestination(for: TicketsRoutes.self) { route in
                    switch route {
                        case .ticketDetails(let ticket):
                            TicketDetailView(
                                ticket: ticket,
                                closeAction: {},
                                editAction: {}
                                
                            )
                    }
                }
        }
    }
}
