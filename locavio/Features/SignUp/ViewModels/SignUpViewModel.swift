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
    
    // função que verifica os documentos - ela puxa as extensões de String que validam CPF ou CNPJ e retorna um bool
    func validateDocument() -> Bool{
        if selectedDocumentType == .pf {
            return documentNumber.isValidCPF
        } else {
            let justNumbers = documentNumber.filter { $0.isNumber }
            return justNumbers.count == 14
        }
    }
}
