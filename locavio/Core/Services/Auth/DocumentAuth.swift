//
//  DocumentAuth.swift
//  locavio
//
//  Created by Julio Sampaio on 04/10/26.
//

import Foundation
import SwiftUI

@Observable
final class DocumentAuth{
    
    // função de validação de documento
    static func isValidDocument(document: String, type: DocumentTypeModel) -> Bool {
        let cleanDocument = document.filter { $0.isNumber }
        
        switch type {
            case .pf:
                return isValidCPF(cleanDocument)
            case .pj:
                return isValidCNPJ(cleanDocument)
        }
    }
    
    private static func isValidCPF(_ cpf: String) -> Bool {
        return cpf.isValidCPF
    }
    
    private static func isValidCNPJ(_ cnpj: String) -> Bool {
        return cnpj.isValidCNPJ
    }
    
    static func applyDocumentMask(to text: String, documentType: DocumentTypeModel) -> String {
        let numbers = Array(text.filter { $0.isNumber })
        var result = ""
        var index = 0
        
        let mask = documentType == .pf ? "###.###.###-##" : "##.###.###/####-##"
        
        for char in mask {
            if index >= numbers.count { break }
            if char == "#" {
                result.append(numbers[index])
                index += 1
            } else {
                result.append(char)
            }
        }
        return result
    }
}
