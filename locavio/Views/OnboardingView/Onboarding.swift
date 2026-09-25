//
//  Onboarding.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 25/09/26.
//

//import SwiftUI
//
//struct OnboardingView: View {
//    @Environment(AppRouter.self) private var router
//    @Bindable var viewModel = TextsOnboardingViewModel()
//
//    var body: some View {
//        OnboardingComponent(viewModel: viewModel, screen: viewModel.currentScreen)
//            .onChange(of: viewModel.finish) { _, finish in
//                if finish {
//                    router.finishOnboarding()
//                }
//            }
//    }
//}
//
//#Preview {
//    OnboardingView()
//        .environment(AppRouter())
//}
