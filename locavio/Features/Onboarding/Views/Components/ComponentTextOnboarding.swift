//
//  ComponentTextOnboarding.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 24/09/26.
//


import SwiftUI

struct ComponentTextOnboarding: View {
    @Bindable var viewModel: TextsOnboardingViewModel
    let screen: Int
    private var texts: OnboardingModel {
        viewModel.screenOnboardings[screen]
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text(texts.titleOnboarding)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(Color.colorOnboarding)
                
                
            Text(texts.subtitleOnboarding)
                .font(.callout)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal,16)
    }
}

#Preview {
    ComponentTextOnboarding(viewModel: TextsOnboardingViewModel(), screen: 0)
}
