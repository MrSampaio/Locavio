//
//  PropertiesViewModel+Validation.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 10/10/26.
//



import Foundation

extension PropertiesViewModel {

    /// Campos do formulário de imóvel que passam pela validação ao salvar
    static let validatedFields: [PropertyFieldType] = [
        .name, .area, .cep, .profit,
        .tenantName, .tenantEmail, .tenantCPF, .tenantPhone
    ]

    // Regras

    /// Lê o valor do draft e devolve a mensagem de erro do campo, ou nil se estiver válido.
    /// As regras seguem as do `addProperty`, mais o formato dos campos preenchidos.
    func validationError(for type: PropertyFieldType) -> String? {
        let tenantNameFilled = !clean(propertyDraft.tenantName).isEmpty

        switch type {
        case .name:
            return clean(propertyDraft.name).isEmpty ? "Informe o nome do imóvel" : nil

        case .area:
            let area = propertyDraft.area
            if area.isEmpty { return "Informe a área" }
            guard let value = Int(area), value > 0 else { return "Área inválida" }
            return nil

        case .cep:
            // opcional, mas se foi preenchido precisa estar completo
            let digits = propertyDraft.cep.onlyDigits
            if digits.isEmpty { return nil }
            return digits.count == 8 ? nil : "O CEP deve ter 8 dígitos"

        case .profit:
            return parseCurrency(propertyDraft.profit) == nil ? "Informe o lucro" : nil

        case .tenantName:
            // o addProperty ignora o inquilino se não tiver nome, então avisa antes de perder os dados
            let hasOtherTenantData = !propertyDraft.tenantCPF.isEmpty || !propertyDraft.tenantPhone.isEmpty
            return (!tenantNameFilled && hasOtherTenantData) ? "Informe o nome do inquilino" : nil

        case .tenantEmail:
            let email = clean(propertyDraft.tenantEmail)
            if email.isEmpty { return nil }
            return emailIsValid(email) ? nil : "Email inválido"

        case .tenantCPF:
            let cpf = propertyDraft.tenantCPF
            if cpf.isEmpty { return tenantNameFilled ? "Informe o CPF do inquilino" : nil }
            return cpf.isValidCPF ? nil : "CPF inválido"

        case .tenantPhone:
            let phone = propertyDraft.tenantPhone.onlyDigits
            if phone.isEmpty { return tenantNameFilled ? "Informe o telefone do inquilino" : nil }
            return phone.count >= 10 ? nil : "Telefone inválido"

        default:
            return nil
        }
    }

    // Quando mostrar o erro

    func markTouched(_ type: PropertyFieldType) {
        touchedFields.insert(type)
    }

    /// O erro só aparece depois que o usuário saiu do campo ou tentou salvar.
    /// Assim ninguém vê vermelho enquanto ainda está digitando pela primeira vez.
    func visibleError(for type: PropertyFieldType) -> String? {
        guard didAttemptSave || touchedFields.contains(type) else { return nil }
        return validationError(for: type)
    }

    /// Marca a tentativa de salvar (mostra todos os erros) e diz se o formulário está válido.
    func validateForm() -> Bool {
        didAttemptSave = true
        return Self.validatedFields.allSatisfy { validationError(for: $0) == nil }
    }

    func resetValidation() {
        touchedFields = []
        didAttemptSave = false
    }

    // Helpers

    private func clean(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func emailIsValid(_ email: String) -> Bool {
        email.range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]{2,}$"#, options: .regularExpression) != nil
    }
}
