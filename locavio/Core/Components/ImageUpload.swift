//
//  ImageUpload.swift
//  locavio
//
//  Created by Mirella Bransford Lourenço on 30/09/26.
//

import SwiftUI

struct ImageUpload: View {
    
    @Binding var image: Image?
    
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            // Card
            RoundedRectangle(cornerRadius: 32)
                .fill(
                    colorScheme == .dark
                    ? Color(red: 28 / 255, green: 28 / 255, blue: 30 / 255)
                    : Color.white
                )
                .frame(maxWidth: .infinity)
                .frame(height: 175)
            
            // Conteúdo do card
            Group {
                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Text("Adicionar Foto do Imóvel")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 175)
            .clipShape(
                RoundedRectangle(cornerRadius: 32)
            )
            
            // Botão da câmera
            Button(action: action) {
                Image(systemName: "camera.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.accentColor)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .offset(x: -18, y: -18)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color(UIColor.appBg)
            .ignoresSafeArea()
        
        ImageUpload(
            image: .constant(nil),
            action: {}
        )
        .padding(.horizontal, 16)
    }
}
