//
//  RecentPayments.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 05/10/26.
//

import SwiftUI
import SwiftData

struct RecentPaymentsView: View {
    @State private var viewModel: RecentPaymentsViewModel

    init(property: Property) {
        _viewModel = State(initialValue: RecentPaymentsViewModel(property: property))
    }

    var body: some View {
        ScrollView {
            if viewModel.isEmpty {
                Text(viewModel.emptyText)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
            } else {
                paymentsCard
                    .padding(16)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $viewModel.proofToShow) { item in
            ProofViewerView(item: item)
        }
    }

    // Cartão

    private var paymentsCard: some View {
        let rows = viewModel.rows

        return VStack(spacing: 0) {
            ForEach(rows) { row in
                paymentRow(row)

                if row.id != rows.last?.id {
                    Divider().padding(.leading, 80)
                }
            }
        }
        .background(
            Color(.secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 32, style: .continuous)
        )
    }

    private func paymentRow(_ row: PaymentRow) -> some View {
        HStack(spacing: 16) {
            Image(systemName: "dollarsign")
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Color.accentColor, in: Circle())

            Text(row.monthText)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)

            Spacer(minLength: 12)

            Button {
                viewModel.showProof(for: row.id)
            } label: {
                Image(systemName: "info.circle")
                    .font(.title)
                    .foregroundStyle(Color.accentColor)
            }
            .buttonStyle(.plain)
            .disabled(!row.hasProof)
            .opacity(row.hasProof ? 1 : 0.35)
            .accessibilityLabel("Ver comprovante")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}



#Preview {
    let container = LastPaymentsPreviewData.makeContainer()
    let property = LastPaymentsPreviewData.makeProperty(in: container.mainContext)

    return NavigationStack {
        RecentPaymentsView(property: property)
    }
    .modelContainer(container)
}

@MainActor
private enum LastPaymentsPreviewData {

    static func makeContainer() -> ModelContainer {
        try! ModelContainer(
            for: Property.self, Owner.self, Tenant.self, Contract.self,
                 Payment.self, Expenses.self, Ticket.self, Maintence.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    static func makeProperty(in context: ModelContext) -> Property {
        let property = Property(title: "Casa 1")
        context.insert(property)

        let pdf = samplePDF()
        let months: [(year: Int, month: Int)] = [(2026, 2), (2026, 1), (2025, 12)]

        for item in months {
            let payment = Payment(date: date(item.year, item.month),
                                  property: property,
                                  proof: pdf)
            context.insert(payment)
        }
        return property
    }

    private static func date(_ year: Int, _ month: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: 10)
        return Calendar.current.date(from: components) ?? .now
    }

    private static func samplePDF() -> Data {
        let bounds = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: bounds)
        return renderer.pdfData { context in
            context.beginPage()
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 28)]
            "Comprovante de pagamento".draw(at: CGPoint(x: 60, y: 80), withAttributes: attributes)
        }
    }
}
