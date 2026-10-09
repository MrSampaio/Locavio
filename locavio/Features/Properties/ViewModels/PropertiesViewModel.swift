//
//  PropertiesViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import Foundation
import Observation
import SwiftData
import PhotosUI
import PDFKit

@Observable
final class PropertiesViewModel {
    
    var searchText = ""
    var filter: PropertyFilter = .todos
    var propertyDraft = PropertyDraft()
    var contractDraft: ContractDraft?
    var property = Property()
    
    let options = PropertyListOptionsViewModel()
    
    func visibleProperties(from properties: [Property]) -> [Property] {
        let bySegment = properties.filter(matchesSegment)
        return options.apply(to: bySegment, search: searchText)
    }
    
    private func matchesSegment(_ property: Property) -> Bool {
        switch filter {
            case .todos: return true
            case .alugados: return property.tenant != nil
            case .naoAlugados: return property.tenant == nil
        }
    }
    
    func calcTotalRent(totalValueExpenses: Double) -> Double {
        return (parseCurrency(propertyDraft.profit) ?? 0) + totalValueExpenses
    }
    
    func parseCurrency(_ text: String) -> Double? {
        let cleaned = text
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .filter { $0.isNumber || $0 == "." }
        return Double(cleaned)
    }
    
    #warning("Depois implementa a lógica de adicionar contrato")
    #warning("também comenta sobre um toggle de `está alugado` ou não")
    
    func setValueToPropertyDraft(_ value: String, propertyFieldType: PropertyFieldType) {
        
        
        switch propertyFieldType {
        case .name:
            propertyDraft.name = value
        case .area:
            propertyDraft.area = value
        case .cep:
            propertyDraft.cep = value
        case .street:
            propertyDraft.street = value
        case .number:
            propertyDraft.number = value
        case .neighborhood:
            propertyDraft.neighborhood = value
        case .city:
            propertyDraft.city = value
        case .federalUnit:
            propertyDraft.federalUnit = value
        case .complement:
            propertyDraft.complement = value
        case .profit:
            propertyDraft.profit = value
        case .payday:
            propertyDraft.payday = value
        case .tenantName:
            propertyDraft.tenantName = value
        case .tenantEmail:
            propertyDraft.tenantEmail = value
        case .tenantCPF:
            propertyDraft.tenantCPF = value
        case .tenantPhone:
            propertyDraft.tenantPhone = value
        }
    }
    
    func addProperty(context: ModelContext, image: Data?, type: PropertyType, expenses: [Expenses], owner: Owner?) throws -> Bool {
        
        guard let currentOwner = owner else { throw PropertiesErrors.invalidOwner }
        
        let cleanTitle = propertyDraft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanTitle.isEmpty {
            throw PropertiesErrors.invalidTitle
        }
        
        guard let convertedArea = Int(propertyDraft.area) else {
            throw PropertiesErrors.invalidArea
        }
        
        guard let convertedProfit = parseCurrency(propertyDraft.profit) else {
            throw PropertiesErrors.invalidProfit
        }
        
        // valida as despesas existentes. caso alguma esteja errada, impede a criação do imóvel
        for data in expenses {
            
            if (data.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw ExpensesErrors.invalidTitle
            }
            
            if data.value == nil {
                throw ExpensesErrors.invalidValue
            }
        }
        
        let newProperty = Property(
            image: image,
            title: cleanTitle,
            type: type,
            area: convertedArea,
            paymentDay: Int(propertyDraft.payday),
            cep: propertyDraft.cep,
            street: propertyDraft.street,
            neighborhood: propertyDraft.neighborhood,
            number: propertyDraft.number,
            city: propertyDraft.city,
            uf: propertyDraft.federalUnit,
            profit: convertedProfit
        )
        
        // cria as despesas depois da validação e depois de criar o imóvel
        for expense in expenses {
            expense.property = newProperty
        }
        
        // adiciona o inquilino caso exista
        if !propertyDraft.tenantName.isEmpty, !propertyDraft.tenantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            var cpf = propertyDraft.tenantCPF
            var phone = propertyDraft.tenantPhone
            
            guard !cpf.isEmpty else {
                throw TenantErrors.invalidCpf
            }
            guard !phone.isEmpty else {
                throw TenantErrors.invalidPhone
            }
            
            let newTenant = Tenant(name: propertyDraft.tenantName, email: propertyDraft.tenantEmail, cpf: cpf, phone: phone)
            
            newTenant.property = newProperty
            newProperty.tenant = newTenant
        }
        
        if let draft = contractDraft {
            let newContract = Contract(
                title: draft.title,
                fileName: draft.fileName,
                createdAt: draft.createdAt,
                pdfData: draft.pdfData
            )
            
            newContract.property = newProperty
            newProperty.contract = newContract
            context.insert(newContract)
        }
        
        
        newProperty.expenses = expenses
        context.insert(newProperty)
        currentOwner.properties?.append(newProperty)
        context.insert(currentOwner)
        
        do {
            try context.save()
            removeContractDraft()
            return true
        } catch {
            print("Error when trying to save a new property: \(error)")
            return false
        }
    }
    
    // função de delete de propriedade
    func deleteProperty(property: Property, context: ModelContext) throws {
        context.delete(property)
    }
    
    // função de update de propriedade
    func updateProperty(context: ModelContext, property: Property, image: Data?, title: String, type: PropertyType, area: String, paymentDay: Int, cep: String, street: String, neighborhood: String, number: String, city: String, uf: String, profit: String) throws -> Bool {
        
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanTitle.isEmpty {
            throw PropertiesErrors.invalidTitle
        }
        
        guard let convertedArea = Int(area) else {
            throw PropertiesErrors.invalidArea
        }
        
        guard let convertedProfit = Double(profit) else {
            throw PropertiesErrors.invalidProfit
        }
        
        property.image = image
        property.title = cleanTitle
        property.type = type
        property.area = convertedArea
        property.paymentDay = paymentDay
        property.cep = cep
        property.street = street
        property.neighborhood = neighborhood
        property.number = number
        property.city = city
        property.uf = uf
        property.profit = convertedProfit
        
        do {
            try context.save()
            return true
        } catch {
            print("Error when trying to save property: \(error)")
            return false
        }
    }
    
    // função de update de inquilino
    func updateTenant(context: ModelContext, tenant: Tenant, name: String, email: String, cpf: String, phone: String) throws -> Bool {
        
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCpf = cpf.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanName.isEmpty {
            throw TenantErrors.invalidName
        }
        
        if cleanCpf.isEmpty {
            throw TenantErrors.invalidCpf
        }
        
        if cleanPhone.isEmpty {
            throw TenantErrors.invalidPhone
        }
        
        tenant.name = cleanName
        tenant.email = email
        tenant.cpf = cleanCpf
        tenant.phone = cleanPhone
        
        do {
            try context.save()
            return true
        } catch {
            print("Erro ao tentar atualizar o inquilino: \(error)")
            return false
        }
    }
    
    // função para salvar as despesas em lote (recebe um array de expenses)
    func saveExpensesBatch(context: ModelContext, property: Property, formDataArray: [ExpenseFormData]) throws -> Bool {
        
        // valida cada elemento do array, caso haja algum incompleto, barra o insert
        for data in formDataArray {
            if data.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw ExpensesErrors.invalidTitle
            }
            if Double(data.value) == nil {
                throw ExpensesErrors.invalidValue
            }
        }
        
        // atualiza cada uma das despesas
        for data in formDataArray {
            
            let validTitle = data.title.trimmingCharacters(in: .whitespacesAndNewlines)
            let validValue = Double(data.value)!
            
            // verifica se a despesa já existe, se sim, atualiza os valores respectivos
            if let existing = data.existingExpense {
                existing.title = validTitle
                existing.value = validValue
                existing.date = data.date
            } else {
                
                // caso não exista, cria uma nova despesa e insere no banco
                let newExpense = Expenses(title: validTitle, value: validValue, date: data.date)
                newExpense.property = property
                context.insert(newExpense)
            }
        }
        
        do {
            try context.save()
            return true
        } catch {
            print("Erro ao tentar salvar lote de despesas: \(error)")
            return false
        }
    }
    
    func importContract(from url: URL) throws {
        guard url.startAccessingSecurityScopedResource() else {
            throw ContractErrors.accessDenied
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        guard url.pathExtension.lowercased() == "pdf" else {
            throw ContractErrors.invalidFile
        }
        
        guard let data = try? Data(contentsOf: url), !data.isEmpty else {
            throw ContractErrors.unreadableFile
        }
        
        guard PDFDocument(data: data) != nil else {
            throw ContractErrors.invalidFile
        }
        
        contractDraft = ContractDraft(fileName: url.lastPathComponent, pdfData: data)
    }
    
    func removeContractDraft() {
        contractDraft = nil
    }
    
    func makeContractPreviewURL() -> URL? {
        guard let draft = contractDraft else { return nil }
        
        let url = URL.temporaryDirectory.appending(path: draft.fileName)
        
        do {
            try draft.pdfData.write(to: url, options: .atomic)
            return url
        } catch {
            print("Erro ao gerar preview do contrato: \(error)")
            return nil
        }
    }
}
