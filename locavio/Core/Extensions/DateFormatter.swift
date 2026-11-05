//
//  DateFormatter.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//

import Foundation

extension Date {
    
    /// Formata a data e o horário conforme o idioma e a região do aplicativo.
    func toTicketFormat(locale: Locale = .current) -> String {
        formatted(Date.FormatStyle(date: .numeric, time: .shortened).locale(locale))
    }
}

//
//if let dataCriacao = ticket.createdAt {
//    Text("Criado em: \(dataCriacao.toTicketFormat())")
//        .font(.caption)
//        .foregroundStyle(.secondary)
//}
