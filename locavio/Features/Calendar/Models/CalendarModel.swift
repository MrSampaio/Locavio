//
//  CalendarModel.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 09/10/26.
//

enum CalendarModel: String, CaseIterable, Identifiable {
    case week = "Semana"
    case month = "Mês"
    var id: Self { self }
}
