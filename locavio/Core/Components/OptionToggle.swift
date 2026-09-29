//
//  RentPaidToggle.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 28/09/26.
//

import SwiftUI

struct OptionToggle: View {
    var text: String
    @Binding var isOn: Bool
    

    var body: some View {
        HStack {
            Text(text)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
//        .background(Color.gray.opacity(0.1))
        .tint(Color.accentColor)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )

        // a caixa inteira é clicável
        .onTapGesture {
            withAnimation {
                isOn.toggle()
            }
        }
    }
}

#Preview {
    OptionToggle(text: "Toggle Text", isOn: .constant(true))
        .padding()
}
