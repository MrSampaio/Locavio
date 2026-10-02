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

enum PropertyFilter: String, CaseIterable, Identifiable {
    case todos = "Todos"
    case alugados = "Alugados"
    case naoAlugados = "Não Alugados"

    var id: Self { self }
}

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
    
    // função de adicionar propriedade
    func addProperty(context: ModelContext, image: Data?, title: String, type: PropertyType, area: Int, paymentDay: Int, isPaid: Bool, cep: String, street: String, neighborhood: String, number: Int, city: String, uf: String, profit: Double) -> Bool {
        
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        //let cleanDescription = noteDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let newProperty = Property(
            image: image,
            title: title,
            type: type,
            area: area,
            paymentDay: paymentDay,
            isPaid: isPaid,
            cep: cep,
            street: street,
            neighborhood: neighborhood,
            number: number,
            city: city,
            uf: uf,
            profit: profit
        )
        
        context.insert(newProperty)
        
        do {
            try context.save()
            return true
        } catch {
            print("Error when trying to save a new property: \(error)")
            return false
        }
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


