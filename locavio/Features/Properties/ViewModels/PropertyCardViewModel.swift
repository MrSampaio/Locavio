//
//  PropertyCardViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 29/09/26.
//

import Foundation
import SwiftUI
import UIKit

@Observable
final class PropertyCardViewModel {
    private let property: Property
    private let calendar: Calendar
    private let today: () -> Date

    init(property: Property,
         calendar: Calendar = .current,
         today: @escaping () -> Date = { Date() }) {
        self.property = property
        self.calendar = calendar
        self.today = today
    }


    var image: UIImage? {
        guard let data = property.image else { return nil }
        return UIImage(data: data)
    }

    var hasImage: Bool { image != nil }

    

    var title: String {
        property.title?.trimmedOrNil ?? "Sem título"
    }

   
    var address: String {
        let streetPart = [property.street?.trimmedOrNil,
                          property.number.map(String.init)]
            .compactMap { $0 }
            .joined(separator: ", ")

        let parts = [streetPart.trimmedOrNil, property.city?.trimmedOrNil]
            .compactMap { $0 }

        return parts.isEmpty ? "Endereço não informado" : parts.joined(separator: " - ")
    }
    

    var badges: [TagBadgeItem] {
        [property.tenantBadge, property.typeBadge, property.areaBadge]
            .compactMap { $0 }
    }
   
    var tenantName: String? {
        let rawName: String? = property.tenant?.name
        return rawName?.trimmedOrNil
    }

    var noTenantText: String { "Nenhum locatário" }



    var rentLabel: String { "Aluguel" }

    var rentText: String {
        guard let profit = property.profit else { return "—" }
        return profit.formatted(
            .currency(code: "BRL").locale(Locale(identifier: "pt_BR"))
        )
    }

  

    var nextPaymentLabel: String { "Próx. Pagamento:" }

    var nextPaymentText: String {
        guard let date = nextPaymentDate else { return "—" }
        return Self.dateFormatter.string(from: date)
    }

   
    private var nextPaymentDate: Date? {
        guard let day = property.paymentDay, (1...31).contains(day) else { return nil }

        let now = today()
        let startOfToday = calendar.startOfDay(for: now)

        for monthOffset in 0...1 {
            guard let month = calendar.date(byAdding: .month, value: monthOffset, to: startOfToday),
                  let range = calendar.range(of: .day, in: .month, for: month) else { continue }

            var comps = calendar.dateComponents([.year, .month], from: month)
            comps.day = min(day, range.count)

            if let candidate = calendar.date(from: comps), candidate >= startOfToday {
                return candidate
            }
        }
        return nil
    }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()
}

private extension String {

    var trimmedOrNil: String? {
        let t = trimmingCharacters(in: .whitespacesAndNewlines)
        return t.isEmpty ? nil : t
    }
}
