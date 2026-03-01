//
//  LoadingUI.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 3/1/26.
//

import SwiftUI

struct LoadingUI: View {
    
    @State private var progress: CGFloat = 0.2
    @State private var offsetX: CGFloat = -120
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.3).ignoresSafeArea()
            VStack(spacing: 4) {
                
                Spacer()
                
                // CAT
                Image(.loading)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                    .offset(x: offsetX)
                    .animation(.linear(duration: 2), value: offsetX)
                
                // PROGRESS BAR
                ZStack(alignment: .leading) {
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.pink.opacity(0.8), lineWidth: 3)
                        .frame(height: 22)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.pinkLight,
                                    Color.pink.opacity(0.8)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: progress * 300, height: 22)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
                .frame(width: 300)
                
                // TEXT
                TextSwiftUI(title: "Loading ... ...", size: 28, color: .pink.opacity(0.8), weight: .bold)
                
                Spacer()
            }
        }
        .onAppear {
            startLoading()
        }
    }
    
    
    func startLoading() {
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            
            if progress < 1 {
                progress += 0.05
                offsetX += 15
            } else {
                timer.invalidate()
            }
        }
    }
}
