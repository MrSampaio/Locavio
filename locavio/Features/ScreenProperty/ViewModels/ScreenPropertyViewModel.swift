//
//  ScreenPropertyViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 26/09/26.
//

//import SwiftUI
//
//@Observable
//final class ScreenPropertyViewModel: ObservableObject {
//    @Published var property: Property
// 
//    init(property: Property) {
//        self.property = property
//    }
// 
//    // Getters simples pra manter a View "burra" (só exibe o que o VM manda)
//    var title: String { property.title }
//    var address: String { property.address }
//    var priceLabel: String { property.priceLabel }
//    var price: String { property.price }
//    var imageURL: String { property.imageURL }
// 
//    var tenantText: String? {
//        guard let tenant = property.tenant else { return nil }
//        return "Locatário: \(tenant)"
//    }
// 
//    var nextPaymentText: String? {
//        guard let date = property.nextPaymentDate else { return nil }
//        return date
//    }
//}
