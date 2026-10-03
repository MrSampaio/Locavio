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

@Observable
final class PropertiesViewModel {
    
    var searchText = ""
    var filter: PropertyFilter = .todos
    
    let options = PropertyListOptionsViewModel()

  
    func visibleProperties(from properties: [Property]) -> [Property] {
        let bySegment = properties.filter(matchesSegment)
        return options.apply(to: bySegment, search: searchText)
    }


    private func matchesSegment(_ property: Property) -> Bool {
        switch filter {
        case .todos:       return true
        case .alugados:    return property.tenant != nil
        case .naoAlugados: return property.tenant == nil
        }
    }
    
    #warning("Depois implementa a lógica de adicionar contrato")
    #warning("também comenta sobre um toggle de `está alugado` ou não")
    // função de adicionar propriedade
    func addProperty(context: ModelContext, image: Data?, title: String, type: PropertyType, area: String, paymentDay: Int, cep: String, street: String, neighborhood: String, number: String, city: String, uf: String, profit: String, expenses: [Expenses], tenantName: String? = nil, tenantEmail: String? = nil, tenantCpf: String? = nil, tenantPhone: String? = nil) throws -> Bool {
        
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        //let cleanDescription = noteDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(cleanTitle.isEmpty){
            throw PropertiesErrors.invalidTitle
        }
        
        guard let convertedArea = Int(area) else {
            throw PropertiesErrors.invalidArea
        }
        
        guard let convertedProfit = Double(profit) else {
            throw PropertiesErrors.invalidProfit
        }
        
        let newProperty = Property(
            image: image,
            title: title,
            type: type,
            area: convertedArea,
            paymentDay: paymentDay,
            cep: cep,
            street: street,
            neighborhood: neighborhood,
            number: number,
            city: city,
            uf: uf,
            profit: convertedProfit,
            expenses: expenses
        )
        
        context.insert(newProperty)
        
        // laço que insere cada despesa e atribui a propriedade (aparentemente se passar direto, o swift data pode perder infos)
        for expense in expenses {
            expense.property = newProperty
        }
        
        // associa o inquilino separadamente também
        if let tName = tenantName, !tName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            guard let cpf = tenantCpf, !cpf.isEmpty else { throw TenantErrors.invalidCpf }
            guard let phone = tenantPhone, !phone.isEmpty else { throw TenantErrors.invalidPhone }
            
            let newTenant = Tenant(name: tName, email: tenantEmail, cpf: cpf, phone: phone)
            newTenant.property = newProperty
        }
        
        do {
            try context.save()
            return true
        } catch {
            print("Error when trying to save a new property: \(error)")
            return false
        }
    }
    
    // função para deletar propriedade
    func deleteProperty(property: Property, context: ModelContext) throws {
        
        context.delete(property)
        
    }
    
    
    

    
    
    
//    func updateProperty(context: ModelContext, property: Property, image: Data?, title: String, type: PropertyType, area: Int, paymentDay: Int, isPaid: Bool, cep: String, street: String, neighborhood: String, number: Int, city: String, uf: String, profit: Double) {
//        
//        property.image = image
//        property.title = title
//        property.type = type
//        property.area = area
//        
//        
//    }
    

    
    
    
}


