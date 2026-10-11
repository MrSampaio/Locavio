//
//  ValueListTextField.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 08/10/26.
//

import SwiftUI

struct ValueListTextField: View {

    @Binding var items: [MaintenceDraft]

    let total: String
    let onDelete: (Int) -> Void
    let onAdd: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    private var cardColor: Color {
        colorScheme == .dark ? .black : .white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Valores")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        Button {
                            onDelete(index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(.plain)

                        TextField(
                            "Item",
                            text: $items[index].item
                        )
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .textFieldStyle(.plain)

                        TextField(
                            "Valor",
                            text: valueBinding(for: index)
                        )
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                        .frame(width: 110)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 54)
                }

                Button {
                    onAdd()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.green)

                        Text("Adicionar valor")
                            .font(.body)
                            .foregroundStyle(.secondary)

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 54)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .background(cardColor)
            .clipShape(RoundedRectangle(cornerRadius: 24))

            HStack {
                Text("Total")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Spacer()

                Text(total)
                    .font(.title3)
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func valueBinding(for index: Int) -> Binding<String> {
        Binding(
            get: {
                guard let value = items[index].value else {
                    return ""
                }

                return String(
                    format: "%.2f",
                    locale: Locale(identifier: "pt_BR"),
                    value
                )
            },
            set: { newValue in
                let normalizedValue = newValue
                    .replacingOccurrences(of: ",", with: ".")

                if normalizedValue.isEmpty {
                    items[index].value = nil
                } else if let value = Double(normalizedValue) {
                    items[index].value = value
                }
            }
        )
    }
}

#Preview("Lista de valores") {
    @Previewable @State var items = [
        MaintenceDraft(item: "Torneira", value: 350),
        MaintenceDraft(item: "Veda-rosca", value: 20)
    ]

    VStack {
        ValueListTextField(
            items: $items,
            total: "R$ 370,00",
            onDelete: { index in
                guard items.indices.contains(index) else {
                    return
                }

                items.remove(at: index)
            },
            onAdd: {
                items.append(
                    MaintenceDraft(item: "", value: nil)
                )
            }
        )
    }
    .padding(16)
    .background(Color(UIColor.appBg))
}
