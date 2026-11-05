//
//  TicketsError.swift
//  locavio
//
//  Created by Julio Sampaio on 08/10/26.
//

import Foundation

enum TicketsError: LocalizedError {
    case invalidTitle
    case savingError
    case generateTicketNumberError
    case editTicketError
    
    var errorDescription: String? {
        switch self {
            case .invalidTitle:
                return String(localized: "Insira um título para o chamado.")
            case .savingError:
                return String(localized: "Erro ao salvar ticket. Verifique os campos e tente novamente.")
            case .generateTicketNumberError:
                return String(localized: "Erro ao gerar o número do ticket. Tente novamente.")
            case .editTicketError:
                return String(localized: "Erro ao editar ticket. Tente novamente.")
        }
    }
}
