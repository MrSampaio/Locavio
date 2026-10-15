//
//  DocumentTypeModel.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation

enum DocumentTypeModel: String, CaseIterable, Codable {
    
    // casos possíveis
    case pf = "Física"
    case pj = "Jurídica"
    
    // description passa a ser o nome extenso (aparece na lista aberta)
    var description: String {
        switch self {
            case .pf: return "Física"
            case .pj: return "Jurídica"
        }
    }
}
