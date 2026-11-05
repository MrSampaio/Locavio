//
//  TextField.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 11/10/26.
//

import SwiftUI

struct TicketInformationTextField: View {
    @Binding var title: String
    @Binding var property: Property?
    @Binding var createdAt: Date
    @Binding var conclusionDate: Date

    let properties: [Property]

    @Environment(\.colorScheme) private var colorScheme

    @Environment(\.locale) private var locale

    private var cardBackground: Color {
        colorScheme == .dark
            ? Color(red: 21 / 255, green: 45 / 255, blue: 57 / 255)
            : .white
    }

    private var dividerColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.12)
            : Color(.separator)
    }

    var body: some View {
        VStack(spacing: 0) {
            row {
                TextField("Título do chamado", text: $title)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            divider

            row {
                Text("Imóvel")
                    .layoutPriority(1)
                Spacer(minLength: 8)
                Picker("Selecione um imóvel", selection: $property) {
                    Text("Nenhum selecionado")
                        .tag(nil as Property?)

                    ForEach(properties) { property in
                        Text(property.title ?? String(localized: "Imóvel"))
                            .tag(property as Property?)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .tint(.secondary)
            }

            divider

            row {
                Text("Data de Registro")
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .layoutPriority(1)
                Spacer(minLength: 8)
                DateCapsule(
                    date: $createdAt,
                    components: .date,
                    text: formattedDate(createdAt),
                    locale: locale
                )
//                DateCapsule(
//                    date: $createdAt,
//                    components: .hourAndMinute,
//                    text: formattedTime(createdAt),
//                    locale: locale
//                )
            }

            divider

            row {
                Text("Até quando resolver")
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .layoutPriority(1)
                Spacer(minLength: 8)
                DateCapsule(
                    date: $conclusionDate,
                    components: .date,
                    text: formattedDate(conclusionDate),
                    locale: locale
                )
            }
        }
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var divider: some View {
        Rectangle()
            .fill(dividerColor)
            .frame(height: 0.5)
            .padding(.horizontal, 16)
    }

    private func row<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 8) {
            content()
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 66)
    }

    private func formattedDate(_ date: Date) -> String {
        date.formatted(.dateTime.day().month(.twoDigits).year().locale(locale))
    }

    private func formattedTime(_ date: Date) -> String {
        date.formatted(.dateTime.hour().minute().locale(locale))
    }
}

private struct DateCapsule: View {
    @Binding var date: Date
    let components: DatePickerComponents
    let text: String
    let locale: Locale

    @Environment(\.colorScheme) private var colorScheme

    private var capsuleColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.12)
            : Color(.systemGray5)
    }

    var body: some View {
        Text(text)
            .font(.body)
            .foregroundStyle(.primary)
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(capsuleColor, in: Capsule())
            .overlay {
                DatePicker("", selection: $date, displayedComponents: components)
                    .labelsHidden()
                    .environment(\.locale, locale)
                    .colorMultiply(.clear)
            }
            .clipShape(Capsule())
    }
}

#Preview {
    @Previewable @State var title = "Trocar torneira"
    @Previewable @State var property: Property? = nil
    @Previewable @State var createdAt = Date()
    @Previewable @State var conclusionDate = Date()

    ZStack(alignment: .top) {
        Color(UIColor.appBg)
            .ignoresSafeArea()

        TicketInformationTextField(
            title: $title,
            property: $property,
            createdAt: $createdAt,
            conclusionDate: $conclusionDate,
            properties: []
        )
        .padding(.horizontal, 16)
        .padding(.top, 24)
    }
}
