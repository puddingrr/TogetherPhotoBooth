//
//  LoadingUI.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 3/1/26.
//

import SwiftUI

struct LoadingUI: View {
    
    @State private var progress: CGFloat = 0
    @State private var bounce = false
    @State private var dots = ""
    
    var body: some View {
        ZStack {
            
            Color.pinkUI.opacity(0.08).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Spacer()
                
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .foregroundColor(.pinkUI)
                    .scaleEffect(bounce ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 0.8).repeatForever(), value: bounce)
                
                VStack(spacing: 16) {
                    
                    ZStack(alignment: .leading) {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.pinkUI.opacity(0.15))
                            .frame(height: 16)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.pinkUI.opacity(0.6),
                                        Color.pinkUI
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: progress * 260, height: 16)
                            .animation(.easeInOut(duration: 0.3), value: progress)
                    }
                    .frame(width: 260)
                    
                    Text("Processing\(dots)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.pinkUI)
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Image(systemName: "heart.fill")
                    Image(systemName: "heart.fill")
                    Image(systemName: "heart.fill")
                }
                .foregroundColor(.pinkUI.opacity(0.5))
                .font(.system(size: 14))
                
                Spacer()
            }
        }
        .onAppear {
            bounce = true
            startLoading()
            animateDots()
        }
    }
    
    func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.18, repeats: true) { timer in
            if progress < 1 {
                progress += 0.04
            } else {
                timer.invalidate()
            }
        }
    }
    
    func animateDots() {
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            if dots.count >= 3 {
                dots = ""
            } else {
                dots += "."
            }
        }
    }
}

struct LoadingUI2: View {
    
    @State private var progress: CGFloat = 0
    @State private var bounce = false
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Spacer()
                
                // Cute Icon
                ZStack {
                    Circle()
                        .fill(Color.pinkUI.opacity(0.15))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(.pinkUI)
                        .offset(y: bounce ? -8 : 8)
                        .animation(.easeInOut(duration: 0.8).repeatForever(), value: bounce)
                }
                
                // Camera icon
                Image(systemName: "camera.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.pinkUI)
                
                // Progress Bar
                ZStack(alignment: .leading) {
                    
                    Capsule()
                        .fill(Color.pinkUI.opacity(0.15))
                        .frame(height: 16)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.pinkUI.opacity(0.6),
                                    Color.pinkUI
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: progress * 260, height: 16)
                        .animation(.easeInOut(duration: 0.25), value: progress)
                }
                .frame(width: 260)
                
                Text("Preparing your photos 💕")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.pinkUI)
                
                Spacer()
                
            }
        }
        .onAppear {
            bounce = true
            startLoading()
        }
    }
    
    func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if progress < 1 {
                progress += 0.04
            } else {
                timer.invalidate()
            }
        }
    }
}
