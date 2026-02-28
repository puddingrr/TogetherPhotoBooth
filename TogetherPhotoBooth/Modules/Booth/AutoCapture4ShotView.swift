//
//  BoothWithLayoutView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/28/26.
//

import SwiftUI

struct AutoCapture4ShotView: View {
    
    @StateObject var viewModel = PhotoBootsViewModel()
    @StateObject var camera = CameraManager()
        
    @State private var countdown = 3
    @State private var isCapturing = false
    @State private var shotIndex = 0
    @State private var countdownTimer: Timer?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CameraPreview(manager: camera)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Color.white.opacity(0.1)
            
            VStack {
                if !isCapturing {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 22, weight: .bold))
                                .scaledToFit()
                                .foregroundColor(.white)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.4))
                                )
                        }
                        
                        Spacer()
                        
                        Button {
                            camera.switchCamera()
                        } label: {
                            Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.camera.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(Color.black.opacity(0.4))
                                )
                        }
                    }
                    .overlay {
                        TextSwiftUI(title:"Ready to Capture!", color: .white, weight: .bold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.black.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.top, 5)
                    }
                } else {
                    TextSwiftUI(title: "\(countdown)", size: 32, color: .white, weight: .bold)
                        .padding(30)
                        .background(Color.black.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.top, 5)
                }
                
                Spacer(minLength: 0)
                if isCapturing {
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            ForEach(0..<4, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 2)
                                        .frame(width: 60, height: 80)
                                        .background(Color.black.opacity(0.2))
                                    
                                    if index < camera.capturedImages.count {
                                        Image(uiImage: camera.capturedImages[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    } else {
                                        Text("\(index+1)")
                                            .foregroundColor(.white.opacity(0.6))
                                            .font(.system(size: 20, weight: .bold))
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                }
                
                Button {
                    startAutoCapture()
                } label: {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding(16)
                        .background(
                            Circle()
                                .fill(Color(hex: "C56E92"))
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 6)
                                .padding(-3)
                        )
                }
                
                TextSwiftUI(title: "Tap to start!", color: .white)
                    .padding(10)
                    .background(Color.black.opacity(0.4))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 5)
                    
            }
            .padding(32)
            .padding(.vertical, 22)
            
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                camera.checkCameraPermissionAndStart()
            }
        }
        .onDisappear {
            camera.stopSession()
        }
    }
    
    func startAutoCapture() {
        
        if isCapturing { return }
        
        isCapturing = true
        shotIndex = 0
        camera.capturedImages = []
        
        startCountdown()
        print("Auto capture Start!!!")
    }
    
    func stopAutoCapture() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isCapturing = false
        print("Auto capture stopped!!!")
    }
    
    func startCountdown() {
        countdown = 3
        
        countdownTimer?.invalidate()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                countdownTimer = nil
                
                camera.capturePhoto()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let img = camera.capturedImage {
                        camera.capturedImages.append(img)
                    }
                    
                    shotIndex += 1
                    
                    if shotIndex < 4 && isCapturing {
                        startCountdown()
                    } else {
                        isCapturing = false
                        print("DONE 4 shots")
                    }
                }
            }
        }
    }
}
