//
//  ViaCepService.swift
//  locavio
//
//  Created by Julio Sampaio on 06/10/26.
//

import Foundation

struct ViaCepService {
    static func fetchAdress(cep: String) async throws{
        
        #warning("Implementar máscara de CEP depois")
        // limpa possíveis caracteres especiais/letras e mantém apenas os números
        let cleanCEP = cep.filter { $0.isNumber }
        
        
        // valida o tamanho depois de limpar
        guard cleanCEP.count == 8 else {
            throw NetworkError.invalidURL
        }
        
        // caso a limpeza dê certo, cria a URL de requisição com o cep limpo
        let url = URL(string: "https://viacep.com.br/ws/\(cleanCEP)/json/")!
        
    }
}
