//
//  Property+payments.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 04/10/26.
//

import Foundation

extension Property {
    /// Pagamentos registrados no mês (e ano) da data informada.
    func payments(inMonthOf date: Date = .now, calendar: Calendar = .current) -> [Payment] {
        (payments ?? []).filter { payment in
            guard let paymentDate = payment.date else { return false }
            return calendar.isDate(paymentDate, equalTo: date, toGranularity: .month)
        }
    }

    /// `true` se já existe pagamento neste mês. Quando o mês vira,
    /// deixa de existir pagamento no mês novo e isto volta a ser `false`.
    func isPaidInMonth(of date: Date = .now, calendar: Calendar = .current) -> Bool {
        !payments(inMonthOf: date, calendar: calendar).isEmpty
    }
}
