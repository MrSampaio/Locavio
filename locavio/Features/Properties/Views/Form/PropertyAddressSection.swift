//
//  PropertyAddressSection.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//


import SwiftUI

struct PropertyAddressSection: View {

    @Environment(PropertiesViewModel.self) private var viewModel

    @Binding var uf: UF
    var onError: (Error) -> Void

    var body: some View {
        Section("Endereço") {
            PropertyLabeledContent(textPropertyLabel: "CEP", iconPropertyLabel: "mappin.and.ellipse", textFieldPlaceholder: "Ex: 12345-678", textFieldHasUnit: false, textFieldIsNumber: true, textFieldCharacterLimit: 9, textFieldType: .cep)
                // ViaCEP: quando o CEP (já com máscara) completa 8 dígitos, busca o endereço.
                // Fica numa linha só: num Section o modificador se repetiria em todas as linhas.
                .onChange(of: viewModel.propertyDraft.cep) { _, newValue in
                    guard newValue.onlyDigits.count == 8 else { return }
                    Task { await lookupCEP(newValue) }
                }

            PropertyLabeledContent(textPropertyLabel: "Rua", iconPropertyLabel: "location", textFieldPlaceholder: "Ex: Rua Ipê Amarelo", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 47, textFieldType: .street)

            PropertyLabeledContent(textPropertyLabel: "Número", iconPropertyLabel: "numero.sign", textFieldPlaceholder: "Ex: 55", textFieldHasUnit: false, textFieldIsNumber: true, textFieldType: .number)

            PropertyLabeledContent(textPropertyLabel: "Bairro", iconPropertyLabel: "map", textFieldPlaceholder: "Ex: Santo Amaro", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 32, textFieldType: .neighborhood)

            PropertyLabeledContent(textPropertyLabel: "Cidade", iconPropertyLabel: "building.2", textFieldPlaceholder: "Ex: São Paulo", textFieldHasUnit: false, textFieldIsNumber: false, textFieldCharacterLimit: 32, textFieldType: .city)

            Picker(selection: $uf) {
                ForEach(UF.allCases) { uf in
                    Text(uf.rawValue).tag(uf)
                }
            } label: {
                Label {
                    Text("UF")
                } icon: {
                    Image(systemName: "flag")
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                }
            }

            PropertyLabeledContent(textPropertyLabel: "Complemento", iconPropertyLabel: "door.left.hand.closed", textFieldPlaceholder: "Ex: Apartamento 21", textFieldHasUnit: false, textFieldIsNumber: false, textFieldType: .complement)
        }
    }

    private func lookupCEP(_ cep: String) async {
        do {
            let address = try await ViaCEPService.fetchAdress(cep: cep)

            // se o usuário mudou o CEP durante a requisição, descarta a resposta antiga
            guard viewModel.propertyDraft.cep.onlyDigits == cep.onlyDigits else { return }

            viewModel.fillAddress(from: address)

            if let code = address.uf, let found = UF(rawValue: code) {
                uf = found
            }
        } catch {
            onError(error)
        }
    }
}
