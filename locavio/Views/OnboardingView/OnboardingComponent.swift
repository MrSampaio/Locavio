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

    var body: some View {
        ZStack {
         
            Image(image.image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

         
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

            VStack{
                Spacer()
                ComponentTextOnboarding(viewModel: viewModel, screen: 0)
                    .padding()
                VStack(spacing: 10){
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
    }
}

#Preview {
    OnboardingComponent(
        viewModel: TextsOnboardingViewModel(), screen: 0)
}
