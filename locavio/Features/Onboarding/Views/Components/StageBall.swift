//
//  StageBall.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 23/09/26.
//

import SwiftUI

struct StageBall: View {

    let currentPage: Int
    let allPages: Int

    var body: some View {
        Text("\(currentPage + 1)/\(allPages)")
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    StageBall(currentPage: 0, allPages: 3)
}
