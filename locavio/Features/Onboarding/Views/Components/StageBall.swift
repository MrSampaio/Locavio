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
        HStack(spacing: 7) {
            
            ForEach(0..<allPages, id: \.self) { index in
                
                Circle()
                    .fill(
                        index == currentPage 
                        ? (Color.primary)
                        : Color.gray.opacity(0.5)
                    )
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    StageBall(currentPage: 1, allPages: 3)
}
