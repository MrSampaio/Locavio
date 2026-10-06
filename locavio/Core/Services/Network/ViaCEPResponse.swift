//
//  ViaCEPResponse.swift
//  locavio
//
//  Created by Julio Sampaio on 06/10/26.
//

import Foundation
import SwiftUI

struct ViaCEPResponse: Codable {
    var cep: String?
    var logradouro: String?
    var bairro: String?
    var estado: String? // cidade
    var uf: String?
    
    var error: String?
}


