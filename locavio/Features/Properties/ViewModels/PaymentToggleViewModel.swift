//
//  PaymentToggleViewModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 04/10/26.
//

import Foundation
import SwiftData
import Observation

@Observable
final class PaymentToggleViewModel {
    private let property: Property
    private let calendar: Calendar
    private let today: () -> Date

    /// Referência de "agora". Ao mudar, a view recalcula o toggle.
    private var now: Date

    init(property: Property,
         calendar: Calendar = .current,
         today: @escaping () -> Date = { Date() }) {
        self.property = property
        self.calendar = calendar
        self.today = today
        self.now = today()
    }

    var title: String { "Aluguel pago?" }

    /// Estado do toggle: ligado só se houver pagamento no mês atual.
    var isPaid: Bool {
        property.isPaidInMonth(of: now, calendar: calendar)
    }

    /// Chame quando o app voltar ao primeiro plano ou o dia mudar.
    func refresh() {
        now = today()
    }

    /// Liga: cria o pagamento do mês. Desliga: remove o pagamento do mês.
    func setPaid(_ paid: Bool, in context: ModelContext) {
        let current = property.payments(inMonthOf: now, calendar: calendar)

        if paid {
            guard current.isEmpty else { return }
            context.insert(Payment(date: now, property: property, value: property.profit))
        } else {
            current.forEach { context.delete($0) }
        }
    }
}
