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
                return "Insira um título para o chamado."
            case .savingError:
                return "Erro ao salvar ticket. Verifique os campos e tente novamente."
            case .generateTicketNumberError:
                return "Erro ao gerar o número do ticket. Tente novamente."
            case .editTicketError:
                return "Erro ao editar ticket. Tente novamente."
        }
    }
}
