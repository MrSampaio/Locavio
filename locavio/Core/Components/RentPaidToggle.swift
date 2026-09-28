//
//  RentPaidToggle.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 28/09/26.
//

import SwiftUI

struct RentPaidToggle: View {
    @Binding var isPaid: Bool

    var body: some View {
        HStack {
            Text("Aluguel pago?")

            Spacer()

            Toggle("", isOn: $isPaid)
                .labelsHidden()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.gray.opacity(0.1))
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
}

#Preview {
    RentPaidToggle(isPaid: .constant(false))
        .padding()
}
