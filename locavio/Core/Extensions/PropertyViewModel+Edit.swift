//
//  PropertyViewModel+Edit.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//

//
//  PropertiesViewModel+Edit.swift
//  locavio
//

import Foundation
import SwiftData

extension PropertiesViewModel {

    // MARK: - Novo cadastro

    /// Zera o draft (e o contrato em edição) para começar um cadastro novo.
    func resetDraft() {
        var draft = PropertyDraft()
        draft.payday = "1"   // o Picker de dia de pagamento começa em 1
        propertyDraft = draft
        removeContractDraft()
    }

    // MARK: - Imóvel -> draft

    /// Copia os dados de um imóvel salvo para o draft, no mesmo formato que o usuário digitaria
    /// (já com máscara), para o formulário de edição abrir preenchido.
    func loadDraft(from property: Property) {
        var draft = PropertyDraft()

        draft.image = property.image
        draft.name = property.title ?? ""

        let area = property.area ?? 0
        draft.area = area == 0 ? "" : String(area)

        draft.cep = (property.cep ?? "").cepMasked
        draft.street = property.street ?? ""
        draft.number = property.number ?? ""
        draft.neighborhood = property.neighborhood ?? ""
        draft.city = property.city ?? ""
        draft.federalUnit = property.uf ?? ""

        // a máscara de moeda trabalha em centavos: 500.0 -> 50000 -> "500,00"
        let cents = Int(((property.profit ?? 0) * 100).rounded())
        draft.profit = String(cents).currencyMasked

        draft.payday = String(property.paymentDay ?? 1)

        draft.tenantName = property.tenant?.name ?? ""
        draft.tenantEmail = property.tenant?.email ?? ""
        draft.tenantCPF = (property.tenant?.cpf ?? "").cpfMasked
        draft.tenantPhone = (property.tenant?.phone ?? "").phoneMasked

        propertyDraft = draft

        // contrato: o formulário trabalha em cima do contractDraft
        if let data = property.contract?.pdfData {
            var contract = ContractDraft(
                fileName: property.contract?.fileName ?? "Contrato.pdf",
                pdfData: data
            )
            if let attachedAt = property.contract?.createdAt {
                contract.createdAt = attachedAt   // mantém a data original do anexo
            }
            contractDraft = contract
        } else {
            contractDraft = nil
        }
    }

    // MARK: - Draft -> imóvel

    /// Grava no imóvel existente o que está no draft. Nada é alterado se alguma validação falhar.
    func applyDraft(to property: Property,
                    context: ModelContext,
                    type: PropertyType,
                    uf: UF,
                    expenses: [Expenses]) throws -> Bool {

        // 1. valida tudo antes de mexer no modelo
        let cleanTitle = propertyDraft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanTitle.isEmpty { throw PropertiesErrors.invalidTitle }

        guard let convertedArea = Int(propertyDraft.area) else {
            throw PropertiesErrors.invalidArea
        }

        guard let convertedProfit = parseCurrency(propertyDraft.profit) else {
            throw PropertiesErrors.invalidProfit
        }

        let tenantName = propertyDraft.tenantName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tenantName.isEmpty {
            guard !propertyDraft.tenantCPF.isEmpty else { throw TenantErrors.invalidCpf }
            guard !propertyDraft.tenantPhone.isEmpty else { throw TenantErrors.invalidPhone }
        }

        // despesas: mesma validação do addProperty
        for expense in expenses {
            if expense.value == nil {
                throw ExpensesErrors.invalidValue
            }
        }

        // 2. dados do imóvel
        property.image = propertyDraft.image
        property.title = cleanTitle
        property.type = type
        property.area = convertedArea
        property.paymentDay = Int(propertyDraft.payday) ?? 1
        property.cep = propertyDraft.cep
        property.street = propertyDraft.street
        property.neighborhood = propertyDraft.neighborhood
        property.number = propertyDraft.number
        property.city = propertyDraft.city
        property.uf = uf.rawValue
        property.profit = convertedProfit

        // 3. inquilino, contrato e despesas
        applyTenant(named: tenantName, to: property, context: context)
        applyContract(to: property, context: context)
        applyExpenses(expenses, to: property, context: context)

        do {
            try context.save()
            removeContractDraft()
            return true
        } catch {
            print("Error when trying to update property: \(error)")
            return false
        }
    }

    // MARK: - Helpers

    private func applyTenant(named name: String, to property: Property, context: ModelContext) {
        if !name.isEmpty {
            if let tenant = property.tenant {
                // já tinha inquilino: atualiza
                tenant.name = name
                tenant.email = propertyDraft.tenantEmail
                tenant.cpf = propertyDraft.tenantCPF
                tenant.phone = propertyDraft.tenantPhone
            } else {
                // não tinha: cria
                let newTenant = Tenant(
                    name: name,
                    email: propertyDraft.tenantEmail,
                    cpf: propertyDraft.tenantCPF,
                    phone: propertyDraft.tenantPhone
                )
                newTenant.property = property
                property.tenant = newTenant
                context.insert(newTenant)
            }
        } else if let tenant = property.tenant {
            // campos do inquilino esvaziados: o imóvel volta a ficar sem inquilino
            property.tenant = nil
            context.delete(tenant)
        }
    }

    private func applyContract(to property: Property, context: ModelContext) {
        switch (contractDraft, property.contract) {

        case (nil, let old?):
            // contrato removido no formulário
            property.contract = nil
            context.delete(old)

        case (let draft?, nil):
            attach(draft, to: property, context: context)

        case (let draft?, let old?):
            // só troca se o arquivo mudou; se for o mesmo, mantém o original (e a data do anexo)
            guard draft.pdfData != old.pdfData else { return }
            property.contract = nil
            context.delete(old)
            attach(draft, to: property, context: context)

        case (nil, nil):
            break
        }
    }

    /// A lista editada é uma cópia: apaga as despesas antigas do imóvel e grava as novas no lugar.
    private func applyExpenses(_ edited: [Expenses], to property: Property, context: ModelContext) {
        for old in property.expenses ?? [] {
            context.delete(old)
        }

        for expense in edited {
            expense.property = property
            context.insert(expense)
        }

        property.expenses = edited
    }

    private func attach(_ draft: ContractDraft, to property: Property, context: ModelContext) {
        let newContract = Contract(
            title: draft.title,
            fileName: draft.fileName,
            createdAt: draft.createdAt,
            pdfData: draft.pdfData
        )
        newContract.property = property
        property.contract = newContract
        context.insert(newContract)
    }
}
