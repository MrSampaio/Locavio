//
//  EditTicketView.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 11/10/26.
//

import SwiftUI
import SwiftData
import UIKit

struct EditTicketView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Query private var properties: [Property]

    @State private var viewModel = EditTicketViewModel()
    @State private var didLoad = false

    let ticket: Ticket

    //@Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                propertyHeader

                TicketInformationTextField(
                    title: $viewModel.title,
                    property: $viewModel.property,
                    createdAt: $viewModel.createdAt,
                    conclusionDate: $viewModel.conclusionDate,
                    properties: properties
                )

                descriptionSection

                ValueListTextField(
                    items: $viewModel.maintences,
                    total: viewModel.formattedTotalMaintence,
                    onDelete: { index in
                        viewModel.removeMaintence(at: index)
                    },
                    onAdd: {
                        viewModel.addMaintenceField()
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .padding(.top, 16)
        }
        .dismissKeyboardOnTap()
        .background(Color.appBg)
        .navigationTitle("Editar chamado")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveChanges()
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.glassProminent)
                .tint(.accentColor)
            }
        }
        .onAppear {
            guard !didLoad else { return }
            viewModel.loadTicket(ticket)
            didLoad = true
        }
    }

    private var propertyHeader: some View {
        VStack(spacing: 12) {
            propertyImage

            Text("Chamado Nº \(ticket.ticketNumber ?? 0)")
                .font(.headline)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var propertyImage: some View {
        if let imageData = ticket.property?.image,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
        } else {
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .padding(30)
                .frame(width: 120, height: 120)
                .background(Color(.systemGray5))
                .foregroundStyle(.secondary)
                .clipShape(Circle())
        }
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Descrição")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            TextField(
                "Descrição do chamado",
                text: $viewModel.ticketDescription,
                axis: .vertical
            )
            .font(.body)
            .foregroundStyle(.secondary)
            .lineLimit(3...6)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.formBg)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }

    private func saveChanges() {
        do {
            try viewModel.saveChanges(ticket: ticket, context: context)
            dismiss()
        } catch {
            print("Error when editing ticket: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack {
        EditTicketView(
            ticket: Ticket(
                title: "Trocar torneira",
                ticketNumber: 121311,
                ticketDescription: "Torneira da cozinha rachou e precisa ser trocada com urgência pois está vazando.",
                createdAt: Date(),
                property: nil,
                isConcluded: false,
                maintence: []
            )
        )
    }
}
