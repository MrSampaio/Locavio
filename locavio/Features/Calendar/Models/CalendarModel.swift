//
//  CalendarModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 09/10/26.
//

import Foundation

enum CalendarModel: String, CaseIterable, Identifiable {
    case week = "Semana"
    case month = "Mês"
    var id: Self { self }

    var displayTitle: String {
        switch self {
        case .week: String(localized: "Semana")
        case .month: String(localized: "Mês")
        }
    }
}
