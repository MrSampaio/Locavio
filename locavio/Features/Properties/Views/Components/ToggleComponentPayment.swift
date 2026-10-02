//
//  Toggle.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 01/10/26.
//

import SwiftUI

struct ToggleComponentPayment: View {
    @State private var condition = false
    @State private var showAlert = false

    var body: some View {
            VStack{
                OptionToggle(
                    text: "Aluguel pago?",
                    isOn: $condition
                )
                .onChange(of: condition) { _, newValue in
                    if newValue {
                        showAlert = true
                    }
                }
                .alert("Confirmar aluguel pago?", isPresented: $showAlert) {
                    Button(role: .confirm) {
                        condition = true
                    } label: {
                        Text("Sim")
                        
                    }
                    
                    Button("Não", role: .cancel) {
                        condition = false
                    }
                }
            }
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
            .frame(maxWidth: .infinity)
            .frame(height: 85)
       
    }
}

#Preview {
    ToggleComponentPayment()
}
