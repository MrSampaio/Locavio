//
//  OnboardingCoordinatorView.swift
//  locavio
//
//  Created by Guilherme Alves de Souza on 25/09/26.
//

//import SwiftUI
//import SwiftData
//struct OnboardingCoordinatorView:View {
//    @State private var router = AppRouter()
//    @AppStorage("onboardingConcluido") private var onboardingConcluido: Bool = false
//    var body: some View {
//        WindowGroup {
//            NavigationStack(path: $router.path) {
//                Group{
//                    if onboardingConcluido {
//                        LoginView(viewModel: LoginViewModel()(repo: (context: PersistenceSwiftData.container.mainContext)))
//                    } else {
//                        OnboardingView()
//                    }
//                }
//            }
//        }
//    }
//}
