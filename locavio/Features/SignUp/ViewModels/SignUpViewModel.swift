//
//  SignUpViewModel.swift
//  locavio
//
//  Created by Julio Sampaio on 26/09/26.
//

import Foundation
import SwiftUI

@Observable
final class SignUpViewModel {
    var selectedDocumentType: DocumentTypeModel = .pf
    var documentNumber: String = ""
    
    // variável computada que verifica em tempo real se o documento é válido
    var isValid: Bool {
        if selectedDocumentType == .pf {
            return documentNumber.isValidCPF
        } else {
            return documentNumber.isValidCNPJ
        }
    }
    
    // variável computada que contém mensagem de erro
    var errorMessage: String? {
        let justNumbers = documentNumber.filter { $0.isNumber }
        let expectedLength = selectedDocumentType == .pf ? 11 : 14
        
        // se já digitou todos os números e a matemática falhou, joga erro
        if justNumbers.count >= expectedLength && !isValid {
            return "Documento inválido."
        }
        
        // retorna nulo se o documento for válido ou se ele ainda tiver digitando
        return nil
    }
    
    // função que injeta a pontuação em tempo real baseada no Enum
    func applyDocumentMask(to text: String) -> String {
        let numbers = Array(text.filter { $0.isNumber })
        var result = ""
        var index = 0
        
        let mask = selectedDocumentType == .pf ? "###.###.###-##" : "##.###.###/####-##"
        
        for char in mask {
            // se os números acabaram, interrompe o loop
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
    
    
    
    // função que verifica os documentos - ela puxa as extensões de String que validam CPF ou CNPJ e retorna um bool
//    func validateDocument() -> Bool{
//        if selectedDocumentType == .pf {
//            return documentNumber.isValidCPF
//        } else {
//            let justNumbers = documentNumber.filter { $0.isNumber }
//            return justNumbers.count == 14
//        }
//    }
}
