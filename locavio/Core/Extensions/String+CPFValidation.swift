//
//  String+Validation.swift
//  locavio
//
//  Created by Julio Sampaio on 27/09/26.
//

import Foundation

extension String {
    
    /// Retorna verdadeiro se a string for um CPF matematicamente válido.
    var isValidCPF: Bool {
        // remove qualquer pontuação (pontos e traços) deixando só os números
        let numbers = self.filter { $0.isNumber }
        
        // verifica se tem exatamente 11 números
        guard numbers.count == 11 else { return false }
        
        // rejeita CPFs com todos os números iguais (ex: 111.111.111-11 passa na matemática, mas é falso)
        if Set(numbers).count == 1 { return false }
        
        // converte os caracteres para um array de inteiros
        let digits = numbers.compactMap { $0.wholeNumberValue }
        
        // cálculo do primeiro dígito verificador
        var sum1 = 0
        for i in 0..<9 {
            sum1 += digits[i] * (10 - i)
        }
        let digit1 = sum1 % 11 < 2 ? 0 : 11 - (sum1 % 11)
        
        // cálculo do segundo dígito verificador
        var sum2 = 0
        for i in 0..<10 {
            sum2 += digits[i] * (11 - i)
        }
        let digit2 = sum2 % 11 < 2 ? 0 : 11 - (sum2 % 11)
        
        // compara os dígitos calculados com os dígitos digitados
        return digits[9] == digit1 && digits[10] == digit2
    }
}
