//
//  DateFormatter.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//

import Foundation

extension Date {
    
    /// Formata a data para exibir em padrão pt-br
    func toTicketFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        // Define o visual: Dia/Mês/Ano Hora:Minuto
        formatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
        
        return formatter.string(from: self)
    }
}

//
//if let dataCriacao = ticket.createdAt {
//    Text("Criado em: \(dataCriacao.toTicketFormat())")
//        .font(.caption)
//        .foregroundStyle(.secondary)
//}
