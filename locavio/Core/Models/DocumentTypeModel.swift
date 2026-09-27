//
//  DocumentTypeModel.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation

enum DocumentTypeModel: String, CaseIterable {
    
    // casos possíveis
    case pf = "PF"
    case pj = "PJ"
    
    // description passa a ser o nome extenso (aparece na lista aberta)
    var description: String {
        switch self {
            case .pf: return "Pessoa Física"
            case .pj: return "Pessoa Jurídica"
        }
    }
}
