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
    
    @State private var countdownTimer: Timer?
    @State private var countdown = 3
    
    @State private var isCapturing: Bool = false
    @State private var isFinishedCapturing: Bool = false
    @State private var isNavUploadPhoto: Bool = false
    
    @State var formCature: Bool = true
    @State var retakeSlotIndex: Int? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CameraPreview(manager: camera)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Color.white.opacity(0.1)
            
            if !isFinishedCapturing {
                VStack {
                    
                    // Navbar
                    if !isCapturing {
                        HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Circle().fill(Color.black.opacity(0.4)))
                            }
                            
                            Spacer()
                            
                            Button { camera.switchCamera() } label: {
                                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .padding(10)
                                    .background(Circle().fill(Color.black.opacity(0.4)))
                            }
                        }
                        .overlay {
                            TextSwiftUI(title: "Ready to Capture!", color: .white, weight: .bold)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.black.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    
                    Spacer()
                    
                    // Slot indicators
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            ForEach(0..<4, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.6),
                                                style: StrokeStyle(lineWidth: 2, dash: [8]))
                                        .frame(width: 60, height: 70)
                                        .background(Color.white.opacity(0.2).cornerRadius(10))
                                    
                                    if index < camera.capturedImages.count && index != retakeSlotIndex {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.pinkUI, lineWidth: 2)
                                            .frame(width: 60, height: 70)
                                            .background(Color.pinkUI.cornerRadius(10))
                                            .overlay {
                                                Text("\(index+1)")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 20, weight: .bold))
                                            }
                                    } else {
                                        Text("\(index+1)")
                                            .foregroundColor(.white.opacity(0.6))
                                            .font(.system(size: 20, weight: .bold))
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Countdown (only for auto capture)
                    if isCapturing && retakeSlotIndex == nil {
                        TextSwiftUI(title: "\(countdown)", size: 32, color: .pinkUI, weight: .bold)
                    }
                    
                    VStack(spacing: 16) {
                        if !isFinishedCapturing {
                            
                            // Auto capture button
                            if retakeSlotIndex == nil {
                                Button {
                                    if !isCapturing {
                                        startAutoCapture()
                                    } else {
                                        stopAutoCapture()
                                    }
                                } label: {
                                    Image(systemName: isCapturing ? "rectangle.ratio.4.to.3.fill" : "camera.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .padding(16)
                                        .background(Circle().fill(Color.pinkUI))
                                        .overlay(
                                            Circle().stroke(Color.white, lineWidth: 6).padding(-3)
                                        )
                                }
                            }
                            
                            // Manual retake button
                            if retakeSlotIndex != nil {
                                Button {
                                    camera.capturedImage = nil
                                    camera.capturePhoto()
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        if let img = camera.capturedImage,
                                           let index = retakeSlotIndex,
                                           camera.capturedImages.indices.contains(index) {
                                            
                                            camera.capturedImages[index] = img
                                            isFinishedCapturing = true
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                retakeSlotIndex = nil
                                                isFinishedCapturing = false
                                                isNavUploadPhoto = true
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .padding(16)
                                        .background(Circle().fill(Color.green))
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                }
                            }
                            
                            TextSwiftUI(title: isCapturing ? "Tap to stop!" : "Tap to start!", color: .white)
                                .padding(10)
                                .background(Color.black.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(36)
            }
            
            if isFinishedCapturing {
                LoadingUI2()
            }
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
        .navigationDestination(isPresented: $isNavUploadPhoto) {
            if !camera.capturedImages.isEmpty {
                UploadPhotoView(images: camera.capturedImages, isPresented: $isNavUploadPhoto, formCapture: true) { index in
                    retakeSlotIndex = index
                    startReCapture()
                }
            }
        }
    }
}

extension AutoCapture4ShotView {
    
    func startAutoCapture() {
        if isCapturing { return }
        isCapturing = true
        startCountdown()
    }
    
    func stopAutoCapture() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isCapturing = false
    }
    
    func startReCapture() {
        isFinishedCapturing = false
        isCapturing = false
        countdown = 3
    }
    
    func startCountdown() {
        countdown = 3
        countdownTimer?.invalidate()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if !isCapturing {
                timer.invalidate()
                return
            }
            
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                
                camera.capturedImage = nil
                camera.capturePhoto()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if let img = camera.capturedImage {
                        camera.capturedImages.append(img)
                    }
                    
                    if camera.capturedImages.count < 4 {
                        startCountdown()
                    } else {
                        isCapturing = false
                        isFinishedCapturing = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            isFinishedCapturing = false
                            isNavUploadPhoto = true
                        }
                    }
                }
            }
        }
    }
}
