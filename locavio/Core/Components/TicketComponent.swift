//
//  TicketComponent.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 08/10/26.
//
import SwiftUI
import SwiftData

struct TicketComponent: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let ticket: Ticket
    var onTap: () -> Void
    
    private var cardBackground: AnyShapeStyle {
           colorScheme == .light
               ? AnyShapeStyle(.quaternary)
               : AnyShapeStyle(Color(.cardBg))
       }
    

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                propertyImage

                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top, spacing: 8) {
                        Text(ticket.title ?? "Sem título")
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        badge
                    }

                    infoRow(icon: "house.fill",
                            text: ticket.property?.title ?? "Sem propriedade")

                    if let date = ticket.conclusionDate {
                        infoRow(icon: "calendar",
                                text: "Em \(date.formatted(date: .numeric, time: .omitted))")
                    }
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
            if let data = ticket.property?.image,
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
        Text(ticket.badgeText)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(Capsule().fill(ticket.badgeColor))
            .fixedSize()
    }
}
