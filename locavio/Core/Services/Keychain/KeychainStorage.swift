//
//  KeychainStorage.swift
//  locavio
//
//  Created by Julio Sampaio on 20/09/26.
//

import SwiftUI

// o KeychainStorage vai ser um atalho para atribuir valores no Kechain do dispositivo
@propertyWrapper
struct KeychainStorage: DynamicProperty{
    
    // exige uma chave e puxa o atalho do KeychainHelper
    private let key: String
    private let helper = KeychainHelper.shared
    
    // por ser uma DynamicProperty, eu posso atribuir o @State pra dizer que pode haver atualização sempre que ocorrer algum evento pela struct
    @State private var value: String
    
    // inicia com os valores existentes. caso não tenha, seta os valores como vazio
    init(wrappedValue: String = "", _ key: String){
        self.key = key
        let existing = KeychainHelper.shared.readString(for: key)
        self._value = State(initialValue: existing ?? wrappedValue)
    }
    
    var wrappedValue: String{
        get{value}
        nonmutating set{
            value = newValue
            if(newValue.isEmpty){
                helper.delete(for: key)
            } else{
                helper.save(newValue, for: key)
            }
        }
    }
}
