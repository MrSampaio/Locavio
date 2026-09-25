//
//  ComponentTextOnboarding.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 24/09/26.
//


import SwiftUI

struct ComponentTextOnboarding: View {
    @Bindable var viewModel: TextsOnboardingViewModel
    
    private var texts: TextsOnboardingModel {
        viewModel.screenOnboardings[0]
    }
    var body: some View {
        VStack{
            Text(texts.titleOnboarding)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(Color.colorOnboarding)
            
            Text(texts.subtitleOnboarding)
                .font(.callout)
        }
    }
}

#Preview {
    ComponentTextOnboarding(viewModel: TextsOnboardingViewModel())
}
