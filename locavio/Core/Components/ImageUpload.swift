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
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            Group {
                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                } else {
                    Text("Adicionar Foto do Imóvel")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 175)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 32)
            )
            .clipped()
            
            Button(action: action) {
                Image(systemName: "camera.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color("ColorOnboarding"))
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
