//
//  TextMask.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 10/10/26.
//

import Foundation


extension String {
    
    var onlyDigits: String {
        filter(\.isNumber)
    }

    /// Aplica um padrão onde `#` é um dígito e qualquer outro caractere é literal.
    /// Os literais só aparecem quando ainda há dígitos depois deles,
    /// então "12345" com "#####-###" continua "12345" (o hífen só entra no 6º dígito).
    /// Dígitos além do tamanho do padrão são descartados.
    func applyMask(_ pattern: String) -> String {
        let digits = onlyDigits
        var result = ""
        var index = digits.startIndex

        for char in pattern {
            guard index < digits.endIndex else { break }

            if char == "#" {
                result.append(digits[index])
                index = digits.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }

    /// CEP: 12345-678
    var cepMasked: String {
        applyMask("#####-###")
    }

    /// CPF: 000.000.000-00
    var cpfMasked: String {
        applyMask("###.###.###-##")
    }

    /// Telefone: (11) 2345-6789 (fixo) ou (11) 91234-5678 (celular)
    var phoneMasked: String {
        applyMask(onlyDigits.count > 10 ? "(##) #####-####" : "(##) ####-####")
    }

    /// Moeda estilo caixa eletrônico: digitar 1, 2, 3, 4, 5 vira "1.234,56" no fim.
    /// O formato é o mesmo que `parseCurrency` do PropertiesViewModel já entende.
    var currencyMasked: String {
        let digits = String(onlyDigits.prefix(11))
        guard let cents = Double(digits) else { return "" }

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: cents / 100)) ?? ""
    }
}



extension PropertyFieldType {
    func format(_ text: String) -> String {
        switch self {
        case .cep:         return text.cepMasked
        case .tenantCPF:   return text.cpfMasked
        case .tenantPhone: return text.phoneMasked
        case .profit:      return text.currencyMasked
        case .area:        return text.onlyDigits
        case .number:      return text.onlyDigits
        default:           return text
        }
    }
}
