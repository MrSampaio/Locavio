//
//  RentComponent.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 15/10/26.
//

import SwiftUI
import SwiftData

/// Card de vencimento de aluguel. Mesmo visual do TicketComponent,
/// mas no contexto do imóvel: foto do imóvel, nome e data de vencimento.
struct RentComponent: View {
    @Environment(\.colorScheme) private var colorScheme

    let property: Property
    let dueDate: Date
    var onTap: () -> Void

    private var cardBackground: AnyShapeStyle {
        colorScheme == .light
            ? AnyShapeStyle(.quaternary)
            : AnyShapeStyle(Color(.cardBg))
    }

    /// Pago no mês do vencimento?
    private var isPaid: Bool {
        !property.payments(inMonthOf: dueDate, calendar: .current).isEmpty
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                propertyImage

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top, spacing: 8) {
                        Text("Aluguel")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        badge
                    }

                    infoRow(icon: "house.fill",
                            text: property.title ?? "Sem título")

                    infoRow(icon: "calendar",
                            text: "Vence em \(dueDate.formatted(date: .numeric, time: .omitted))")
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(cardBackground)
            )
            .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .frame(width: 18)
            Text(text)
                .lineLimit(1)
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private var propertyImage: some View {
        Group {
            if let data = property.image,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 72, height: 72)
        .clipShape(Circle())
    }

    private var badge: some View {
        Text(isPaid ? "Pago" : "Pendente")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(Capsule().fill(isPaid ? Color(BadgeColor.rented) : Color(.accent)))
            .fixedSize()
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Property.self, Owner.self, Tenant.self, Contract.self,
             Payment.self, Expenses.self, Ticket.self, Maintence.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = container.mainContext
    let image = UIImage(named: "CasaText")?.jpegData(compressionQuality: 0.9)

    // um imóvel com o aluguel do mês pago e outro pendente
    let paid = Property(image: image, title: "Casa 1", type: .home, paymentDay: 10)
    let pending = Property(image: image, title: "Galpão de Carro", type: .warehouse, paymentDay: 10)
    context.insert(paid)
    context.insert(pending)
    context.insert(Payment(date: .now, property: paid, value: 1200))

    return VStack(spacing: 16) {
        RentComponent(property: paid, dueDate: .now, onTap: {})
        RentComponent(property: pending, dueDate: .now, onTap: {})
    }
    .padding()
    .modelContainer(container)
}
