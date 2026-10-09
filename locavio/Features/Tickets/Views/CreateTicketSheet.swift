//
//  CreateTicketSheet.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateTicketSheet: View {
    
    @State private var viewModel = TicketsViewModel()
    @Query var properties: [Property]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    var onAdd: () -> Void = {}
    var onClose: () -> Void = {}
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    
                    textFields
                    
                    datePickerSection
                    
                    propertyPickerSection
                    
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .padding(.top, 16)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                SheetsToolbar(
                    onConfirm: {
                        do {
                            try viewModel.createTicket(context: context)
                            
                            dismiss()
                            
                        } catch {
                            print("Erro when trying to save a new ticket: \(error)")
                        }
                    },
                    onClose: {
                        dismiss()
                    },
                    title: "Adicionar Chamado"
                )
            }
        }
    }
    
    @ViewBuilder
    var textFields: some View {
        VStack(spacing: 0) {
            TextField("Título", text: $viewModel.ticketTitle)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            
            Divider()
                .padding(.leading, 16)
            
            TextField("Descrição", text: $viewModel.ticketDescription)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
        }
        .background(Color(.systemGray5))
        .cornerRadius(20)
    }
    
    @ViewBuilder
    var datePickerSection: some View {
        VStack(spacing: 12) {
            CustomDatePicker(date: $viewModel.createdAt, inputTitle: "Data de registro")
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray5))
                .cornerRadius(20)
            
            CustomDatePicker(
                date: $viewModel.conclusionDate,
                inputTitle: "Até quando resolver"
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray5))
            .cornerRadius(20)
        }
    }
    
    @ViewBuilder
    var propertyPickerSection: some View {
        HStack {
            Text("Imóvel")
                .foregroundColor(.primary)
            
            Spacer()
            
            Picker("Selecione um imóvel", selection: $viewModel.property) {
                Text("Nenhum selecionado").tag(nil as Property?)
                
                ForEach(properties) { property in
                    Text(property.title ?? "Imóvel").tag(property as Property?)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
            .frame(minHeight: 50)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray5))
        .cornerRadius(20)
    }
}

#Preview {
    CreateTicketSheet()
}
