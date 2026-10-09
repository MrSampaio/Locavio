//
//  ContractDraft.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 08/10/26.
//

import Foundation

struct ContractDraft {
    let fileName: String
    let pdfData: Data
    let createdAt: Date = .now
    
    var title: String {
        (fileName as NSString).deletingPathExtension
    }
}

enum ContractErrors: LocalizedError {
    case accessDenied
    case invalidFile
    case unreadableFile
    
    var errorDescription: String? {
        switch self {
        case .accessDenied: return "Não foi possível acessar o arquivo selecionado."
        case .invalidFile: return "O arquivo selecionado não é um PDF válido."
        case .unreadableFile: return "Não foi possível ler o conteúdo do arquivo."
        }
    }
}
