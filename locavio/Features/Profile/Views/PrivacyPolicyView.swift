//
//  PrivacyPolicyView.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 29/09/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Esta Política de Privacidade descreve como o Locavio coleta, usa, armazena e protege os dados pessoais dos usuários (proprietários de imóveis) e de terceiros cujos dados sejam inseridos no aplicativo (inquilinos), em conformidade com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018 — LGPD).")
                
                Text("1. Interpretação e Definições")
                    .font(.headline)
                    .padding(.top, 8)
                
                Text("1.1 Definições")
                    .font(.subheadline.bold())
                
                Text("Para os fins desta Política de Privacidade:")
                
                ListCardComponent(textList: ".background(.listCard)")
            }
            .font(.caption2)
        }
        .padding()
    }
}

#Preview {
    PrivacyPolicyView()
}
