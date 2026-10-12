//
//  Onboarding1View.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 25/09/26.
//

import SwiftUI

struct OnboardingComponent: View {
    @Bindable var viewModel: TextsOnboardingViewModel
    @Environment(\.colorScheme) private var colorScheme
    let screen: Int

    private var image: OnboardingModel {
        viewModel.screenOnboardings[screen]
    }

    private var blurColor: Color {
        colorScheme == .dark ? Color(hex: "152D39") : Color(hex: "EFE1CE")
    }

    
    private var slide: AnyTransition {
        viewModel.isGoingForward
            ? .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
            : .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
    }

    /// Botão de voltar: só aparece a partir da segunda tela.
    @ViewBuilder
    private var backButton: some View {
        if viewModel.currentScreen > 0 {
            Button {
                viewModel.back()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .padding(.leading, 20)
            .transition(.opacity)
            .accessibilityLabel("Voltar")
        }
    }

    var body: some View {
        ZStack {
        
            Image(image.image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .id(screen)
                .transition(slide)

           
            VStack {
                Spacer()
                LinearGradient(
                    stops: [
                        .init(color: blurColor.opacity(0), location: 0),
                        .init(color: blurColor.opacity(0.55), location: 0.25),
                        .init(color: blurColor.opacity(0.85), location: 0.45),
                        .init(color: blurColor, location: 0.55),
                        .init(color: blurColor, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 620)
            }

            VStack {
                Spacer()

                
                ComponentTextOnboarding(viewModel: viewModel, screen: screen)
                    .padding()
                    .id(screen)
                    .transition(slide)

                
                VStack(spacing: 10) {
                    ComponentButton(textButton: "Continuar") {
                        viewModel.continueOnboarding()
                    }
                    .frame(width: 200, height: 50)

                    StageBall(
                        currentPage: viewModel.currentScreen,
                        allPages: viewModel.allScreen
                    )
                }
                .padding(.trailing, 50)
            }
            .padding(.bottom, 50)
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) { backButton }
        .animation(.easeInOut(duration: 0.4), value: screen)
    }
}

#Preview {
    OnboardingComponent(viewModel: TextsOnboardingViewModel(), screen: 0)
}
