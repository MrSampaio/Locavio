//
//  PropertyPhotoSection.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 12/10/26.
//


import SwiftUI
import PhotosUI
import TipKit

struct PropertyPhotoSection: View {

    @Environment(PropertiesViewModel.self) private var viewModel
    @State private var selectedImage: PhotosPickerItem?

    /// Dica opcional (só a tela de adicionar mostra)
    var tip: (any Tip)? = nil

    var body: some View {
        let propertyImage = viewModel.propertyDraft.image

        PhotosPicker(selection: $selectedImage, matching: .images) {
            VStack {
                if let image = propertyImage, let uiImage = UIImage(data: image) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 175)
                } else {
                    VStack {
                        Text("Adicionar Foto do Imóvel")
                            .foregroundStyle(.black)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 175)
                    .background(.white)
                }
            }
            .popoverTip(tip)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "camera.fill")
                    .font(.subheadline)
                    .padding(15)
                    .foregroundStyle(.white)
                    .background(.imageFieldCameraInput)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.systemGroupedBackground), lineWidth: 3))
                    .offset(x: 10, y: 10)
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        .buttonStyle(.plain)
        .onChange(of: selectedImage) { _, newImage in
            Task {
                let data = await viewModel.loadImage(from: newImage)
                viewModel.propertyDraft.image = data
            }
        }
    }
}
