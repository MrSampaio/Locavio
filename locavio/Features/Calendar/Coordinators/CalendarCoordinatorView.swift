//
//  CalendarCoordinatorView.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftData
import SwiftUI

struct CalendarCoordinatorView: View {
    @State private var calendarCoordinator = CalendarCoordinator()
    @Environment(\.modelContext) private var modelContext
    @State private var propertiesViewModel = PropertiesViewModel()

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
                        EditTicketView(ticket: ticket)

                    case .propertyDetails(let property):
                        PropertyDetailView(
                            property: property,
                            onEdit: {
                                calendarCoordinator.pushToEditProperty(property: property)
                            },
                            onShowLastPayments: {
                                calendarCoordinator.pushToLastPayments(property: property)
                            },
                            onDelete: {
                                delete(property)
                            }
                        )

                    case .editProperty(let property):
                        EditPropertyView(property: property)
                            .environment(propertiesViewModel)

                    case .lastPayments(let property):
                        RecentPaymentsView(property: property)
                    }
                }
        }
    }

    private func delete(_ property: Property) {
        calendarCoordinator.pop()

        DispatchQueue.main.async {
            propertiesViewModel.deleteProperty(
                property: property,
                context: modelContext
            )
        }
    }
}
