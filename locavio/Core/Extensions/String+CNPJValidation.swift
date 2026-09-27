//
//  String+CNPJValidation.swift
//  locavio
//
//  Created by Julio Sampaio on 27/09/26.
//

import Foundation

extension String{
    
    /// Retorna verdadeiro se a string for um CNPJ matematicamente válido.
    var isValidCNPJ: Bool {
        // remove pontuações
        let numbers = self.filter { $0.isNumber }
        
        // CNPJ precisa ter exatamente 14 números
        guard numbers.count == 14 else { return false }
        
        // rejeita CNPJs com todos os números iguais (ex: 00000000000000)
        if Set(numbers).count == 1 { return false }
        
        let digits = numbers.compactMap { $0.wholeNumberValue }
        
        // cálculo do primeiro dígito verificador
        let weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        var sum1 = 0
        for i in 0..<12 {
            sum1 += digits[i] * weights1[i]
        }
        let remainder1 = sum1 % 11
        let digit1 = remainder1 < 2 ? 0 : 11 - remainder1
        
        // cálculo do segundo dígito verificador
        let weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        var sum2 = 0
        for i in 0..<13 {
            sum2 += digits[i] * weights2[i]
        }
        let remainder2 = sum2 % 11
        let digit2 = remainder2 < 2 ? 0 : 11 - remainder2
        
        // compara os dígitos calculados com os digitados
        return digits[12] == digit1 && digits[13] == digit2
    }
}

