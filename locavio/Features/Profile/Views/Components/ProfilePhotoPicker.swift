//
//  PhotoPicker.swift
//  locavio
//
//  Created by Julio Sampaio on 04/10/26.
//

import Foundation
import SwiftUI
import PhotosUI

struct ProfilePhotoPicker: View {
    
    // binding para conectar a imagem
    @Binding var imageData: Data?
    
    // estado interno temporário que guarda o item selecionado na galeria
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack(spacing: 12) {
            
            // o pPhotosPicker envolve a área clicável que abre a galeria
            PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                
                // layout circular com o ícone sobreposto
                ZStack(alignment: .bottomTrailing) {
                    
                    // imagem principal do usuário
                    Group {
                        if let data = imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            // placeholder caso o usuário ainda não tenha foto
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color.secondary)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    
                    // badge da Câmera
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
            }
            // conversão assíncrona da seleção
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    // tenta carregar os dados da imagem em data em segundo plano
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        // atualiza a variável ligada ao banco de dados
                        imageData = data
                    }
                }
            }
        }
    }
}

#Preview {
    ProfilePhotoPicker(imageData: .constant(nil))
}
