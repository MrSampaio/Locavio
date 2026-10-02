//
//  Badges.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 30/09/26.
//

import SwiftUI

struct TagBadgeView: View {
    let text: String
    let color: Color

    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }

    init(_ item: TagBadgeItem) {
        self.init(text: item.text, color: item.color)
    }

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .lineLimit(1)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(color, in: Capsule())
    }
}

#Preview {
    HStack {
        TagBadgeView(text: "Casa", color: .brown)
        TagBadgeView(text: "Aberto", color: .orange)
        TagBadgeView(text: "Concluído", color: .green)
    }
    .padding()
}
