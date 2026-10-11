//
//  ViaCEPService.swift
//  locavio
//
//  Created by Julio Sampaio on 06/10/26.
//

import Foundation
 
struct ViaCEPService {
    static func fetchAdress(cep: String) async throws -> ViaCEPResponse {
 
        // aceita o CEP com ou sem máscara: mantém apenas os números
        let cleanCEP = cep.onlyDigits
 
        // valida o tamanho depois de limpar
        guard cleanCEP.count == 8 else {
            throw NetworkError.invalidURL
        }
 
        guard let url = URL(string: "https://viacep.com.br/ws/\(cleanCEP)/json/") else {
            throw NetworkError.invalidURL
        }
 
        // data é o JSON da api e response é o status (200, 404, etc)
        let (data, response) = try await URLSession.shared.data(from: url)
 
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
 
        let address = try JSONDecoder().decode(ViaCEPResponse.self, from: data)
 
        // CEP com 8 dígitos, mas que não existe
        if address.erro {
            throw NetworkError.notFound
        }
 
        return address
    }
}
