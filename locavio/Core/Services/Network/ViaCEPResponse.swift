    //
    //  ViaCEPResponse.swift
    //  locavio
    //
    //  Created by Julio Sampaio on 06/10/26.
    //

import Foundation
 
struct ViaCEPResponse: Decodable {
    let cep: String?
    let logradouro: String?
    let bairro: String?
    let localidade: String?   // cidade (o campo "estado" do ViaCEP é o nome do estado, ex.: "São Paulo")
    let uf: String?           // sigla, ex.: "SP"
    let erro: Bool            // CEP no formato certo, mas que não existe
 
    private enum CodingKeys: String, CodingKey {
        case cep, logradouro, bairro, localidade, uf, erro
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
 
        cep = try container.decodeIfPresent(String.self, forKey: .cep)
        logradouro = try container.decodeIfPresent(String.self, forKey: .logradouro)
        bairro = try container.decodeIfPresent(String.self, forKey: .bairro)
        localidade = try container.decodeIfPresent(String.self, forKey: .localidade)
        uf = try container.decodeIfPresent(String.self, forKey: .uf)
 
        // o ViaCEP já devolveu "erro" como string ("true") e como booleano (true),
        // então aceita os dois formatos. Se a chave não existe, não houve erro.
        if let flag = try? container.decode(Bool.self, forKey: .erro) {
            erro = flag
        } else if let text = try? container.decode(String.self, forKey: .erro) {
            erro = (text == "true")
        } else {
            erro = false
        }
    }
}


