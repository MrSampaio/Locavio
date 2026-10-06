//
//  ViaCEPService.swift
//  locavio
//
//  Created by Julio Sampaio on 06/10/26.
//

import Foundation

struct ViaCEPService {
    static func fetchAdress(cep: String) async throws -> ViaCEPResponse{
        
        #warning("Implementar máscara de CEP depois")
        // limpa possíveis caracteres especiais/letras e mantém apenas os números
        let cleanCEP = cep.filter { $0.isNumber }
        
        // valida o tamanho depois de limpar
        guard cleanCEP.count == 8 else {
            throw NetworkError.invalidURL
        }
        
        // caso a limpeza dê certo, cria a URL de requisição com o cep limpo
        let url = URL(string: "https://viacep.com.br/ws/\(cleanCEP)/json/")!
        
        // tupla com dois retornos, data é o JSON da api e o response é o status (200, 404, etc)
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // testa o response, caso seja diferente de 200, joga erro
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        // tenta decodificar o .json da tupla e manda pra um objeto ViaCEPResponse
        let address = try JSONDecoder().decode(ViaCEPResponse.self, from: data)
        
        if address.error == "true" {
            throw NetworkError.notFound
        }
        
        return address
        
    }
}
