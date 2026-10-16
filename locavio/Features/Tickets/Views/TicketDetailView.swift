//
//  CallDetailView.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 07/10/26.
//

import SwiftUI
import UIKit
import TipKit

struct TicketDetailView: View {

    @Environment(\.dismiss) private var dismiss
//    @Environment(TicketsCoordinator.self) private var ticketsCoordinator
    @State private var viewModel = TicketsViewModel()
    
   
    
    let ticket: Ticket
    var editAction: () -> Void

    private var status: String {
        ticket.isConcluded == true ? "Concluído" : "Aberto"
    }

    private var items: [(name: String, value: String)] {
        ticket.maintence?.compactMap { maintenance in
            guard let item = maintenance.item,
                  !item.isEmpty else {
                return nil
            }

            return (
                name: item,
                value: formatCurrency(maintenance.value ?? 0)
            )
        } ?? []
    }

    private var total: String {
        let total = ticket.maintence?
            .compactMap(\.value)
            .reduce(0, +) ?? 0

        return formatCurrency(total)
    }

    private var propertyName: String {
        ticket.property?.title ?? "Imóvel não informado"
    }

    private var date: String {
        formatDate(ticket.createdAt)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                propertyImage

                TicketTitle(
                    title: ticket.title ?? "Sem título",
                    callNumber: String(ticket.ticketNumber ?? 0),
                    status: status,
                    propertyName: propertyName,
                    date: date
                )

                TicketDescriptionText(
                    description: ticket.ticketDescription ?? "Sem descrição.",
                    items: items,
                    total: total,
                    isConcluded: ticket.isConcluded ?? false,
                    closeAction: {
                        viewModel.showCloseAlert = true
                    },
                    reopenAction: {
                        viewModel.showReopenAlert = true
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .toolbar(.hidden, for: .tabBar)
        .background(Color.appBg)
        .navigationTitle("Detalhes do chamado")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditToolbar(
                onClick: {
                editAction()
            })
        }
        .alert("Fechar Chamado", isPresented: $viewModel.showCloseAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Confirmar", role: .destructive) {
                withAnimation {
                    ticket.close()
                }
            }
        } message: {
            Text("Tem certeza que deseja marcar este chamado como concluído? Essa ação atualizará o status e a data de encerramento.")
        }
        
        .alert("Reabrir Chamado", isPresented: $viewModel.showReopenAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Confirmar") {
                withAnimation {
                    ticket.reopen()
                }
            }
        } message: {
            Text("Tem certeza que deseja reabrir este chamado? O status voltará para 'Aberto'.")
        }
    }

    @ViewBuilder
    private var propertyImage: some View {

        if let imageData = ticket.property?.image,
           let uiImage = UIImage(data: imageData) {

            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())

        } else {

            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .padding(35)
                .frame(width: 150, height: 150)
                .background(Color(.systemGray6))
                .foregroundStyle(.tertiary)
                .clipShape(Circle())
        }
    }

    private func formatDate(_ date: Date?) -> String {

        guard let date else {
            return "Data não informada"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"

        return formatter.string(from: date)
    }

    private func formatCurrency(_ value: Double) -> String {

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        return formatter.string(
            from: NSNumber(value: value)
        ) ?? "R$ 0,00"
    }
}

#Preview {
    NavigationStack {

        let property = Property(
            image: nil,
            title: "Casa 1",
            type: .home
        )

        let ticket = Ticket(
            title: "Trocar torneira",
            ticketNumber: 121311,
            ticketDescription: "Torneira da cozinha rachou e precisa ser trocada com urgência pois está vazando.",
            createdAt: Date(),
            property: property,
            isConcluded: false,
            maintence: [
                Maintence(
                    item: "Torneira",
                    value: 350
                ),
                Maintence(
                    item: "Veda Rosca",
                    value: 20
                )
            ]
        )

        TicketDetailView(
            ticket: ticket,
//            closeAction: {
//                print("Chamado fechado")
//            },
            editAction: {
                print("Editar chamado")
            }
        )
        .environment(TicketsCoordinator())
    }
}
