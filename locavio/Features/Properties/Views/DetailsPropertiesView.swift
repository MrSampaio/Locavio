//
//  DetailsProperties.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 03/10/26.
//

import SwiftUI
import SwiftData

struct PropertyDetailView: View {
    let property: Property
    var onEdit: () -> Void = {}
    var onOpenContract: () -> Void = {}
    var onShowLastPayments: () -> Void = {}
    var onDelete: () -> Void = {}

    @State private var viewModel: PropertyDetailViewModel
    @State private var showDeleteAlert = false

    init(property: Property,
         onEdit: @escaping () -> Void = {},
         onOpenContract: @escaping () -> Void = {},
         onShowLastPayments: @escaping () -> Void = {},
         onDelete: @escaping () -> Void = {}) {
        self.property = property
        self.onEdit = onEdit
        self.onOpenContract = onOpenContract
        self.onShowLastPayments = onShowLastPayments
        self.onDelete = onDelete
        _viewModel = State(initialValue: PropertyDetailViewModel(property: property))
    }

    var body: some View {
        ZStack(alignment: .top) {
            background

            ScrollView {
                VStack(spacing: 0) {
                    // espaço onde a foto aparece
                    Color.clear
                        .containerRelativeFrame(.vertical) { height, _ in height * 0.46 }

                    panel
                }
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(viewModel.hasImage ? .dark : nil, for: .navigationBar)
        .toolbar {
            ToolbarDetailsComponentView(onEdit: onEdit)
        }
        .alert(viewModel.deleteAlertTitle, isPresented: $showDeleteAlert) {
            Button(viewModel.deleteButtonTitle, role: .destructive) {
                onDelete()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text(viewModel.deleteAlertMessage)
        }
    }

    @ViewBuilder
    private var background: some View {
        if let uiImage = viewModel.image {
            Color.clear
                .overlay {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                }
                .clipped()
                .ignoresSafeArea()
        } else {
            Color(.systemGray4)
                .overlay(alignment: .top) {
                    Image(systemName: "photo")
                        .font(.system(size: 64))
                        .foregroundStyle(Color(.systemGray))
                        .padding(.top, 140)
                }
                .ignoresSafeArea()
        }
    }

    // Painel

    private var panel: some View {
        VStack(alignment: .leading, spacing: 20) {
            header

            ExpensesCardView(property: property)

            ToggleComponentPayment(property: property)

            TenantSectionView(viewModel: viewModel)

            section(viewModel.contractSectionTitle) {
                ViewContractComponent(
                    contractName: viewModel.contractDisplayName,
                    attachmentDate: viewModel.contractAttachmentDate,
                    action: onOpenContract
                )
            }

            section(viewModel.requestsSectionTitle) {
                RequestsComponentView(property: property)
            }

            actionButtons
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32, style: .continuous)
                .fill(.regularMaterial)
                .padding(.bottom, -1000)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                if let badge = viewModel.typeBadge {
                    TagBadgeView(badge)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 0) {
                    Text(viewModel.nextPaymentLabel)
                    Text(viewModel.nextPaymentText).fontWeight(.semibold)
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }

            HStack(spacing: 14) {
                Text(viewModel.title)
                if let area = viewModel.areaText {
                    Text("·")
                    Text(area)
                }
            }
            .font(.largeTitle.bold())
            .lineLimit(1)
            .minimumScaleFactor(0.7)

            Text(viewModel.address)
                .font(.subheadline)

            Text(viewModel.cepText)
                .font(.subheadline)
        }
    }


    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: onShowLastPayments) {
                Text(viewModel.lastPaymentsButtonTitle)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.quaternary, in: Capsule())
            }
            .buttonStyle(.plain)

            Button {
                showDeleteAlert = true
            } label: {
                Text(viewModel.deleteButtonTitle)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.quaternary, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 4)
    }

    private func section<Content: View>(_ title: String,
                                        @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    let container = PreviewData.makeContainer()
    let property = PreviewData.makeProperty(in: container.mainContext)

    return NavigationStack {
        PropertyDetailView(property: property)
    }
    .modelContainer(container)
}


@MainActor
private enum PreviewData {

    static func makeContainer() -> ModelContainer {
        try! ModelContainer(
            for: Property.self, Owner.self, Tenant.self, Contract.self,
                 Payment.self, Expenses.self, Ticket.self, Maintence.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    static func makeProperty(in context: ModelContext) -> Property {
        let property = makeBaseProperty()
        context.insert(property)

        addExpenses(to: property, in: context)
        addTickets(to: property, in: context)

        return property
    }



    private static func makeBaseProperty() -> Property {
        let tenant = Tenant(name: "Alberto Caeiro",
                            email: "bertinhocaeiro@fpessoa.com",
                            cpf: "12345678901")

        let imageData: Data? = UIImage(named: "CasaText")?.jpegData(compressionQuality: 0.9)

        return Property(
            image: imageData,
            title: "Casa 1",
            type: .home,
            area: 32,
            paymentDay: 10,
            cep: "12345678",
            street: "Rua Ipê Amarelo",
            neighborhood: "Santo Amaro",
            number: "55",
            uf: "SP",
            profit: 1200,
            tenant: tenant
        )
    }

    private static func addExpenses(to property: Property, in context: ModelContext) {
        let items: [(title: String, value: Double)] = [
            ("IPTU", 200),
            ("Condomínio", 400),
            ("Seguro", 200),
            ("Lucro", 400)
        ]

        for item in items {
            let expense = Expenses(property: property, title: item.title, value: item.value)
            context.insert(expense)
        }
    }

    private static func addTickets(to property: Property, in context: ModelContext) {
        let ticket1 = Ticket(title: "Torneira",
                             conclusionDate: date(2026, 9, 27),
                             property: property)
        let ticket2 = Ticket(title: "Fiação",
                             conclusionDate: date(2026, 10, 10),
                             property: property)
        context.insert(ticket1)
        context.insert(ticket2)

        context.insert(Maintence(ticket: ticket1, item: "Trocar Torneira", value: 150))
        context.insert(Maintence(ticket: ticket2, item: "Arrumar Fiação", value: 400))
    }

    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components) ?? .now
    }
}
