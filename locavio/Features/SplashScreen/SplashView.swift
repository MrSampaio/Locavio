//
//  SplashView.swift
//  locavio
//
//  Created by Julio Sampaio on 06/10/26.
//

import Foundation
import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void = {}
    
    var body: some View {
        ZStack(alignment: .center){
            
            Color(.black)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                VideoPlayerView(
                    fileName: "locavio_black",
                    fileExtension: "mp4",
                    onFinish: onFinish
                )
                .frame(width: 300, height: 300)
            }
            .padding(.bottom, 80)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(500))
//            SoundManager.shared.playSound(named: .splash)
        }
        
        
    }
}

#Preview {
    SplashView()
}
