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
    @State private var shotIndex = 0
    
    @State private var isCapturing: Bool = false
    @State private var isFinishedCapturing: Bool = false
    @State private var isNavUploadPhoto: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CameraPreview(manager: camera)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Color.white.opacity(0.1)
            
            if !isFinishedCapturing {
                VStack {
                    // MARK: -  Navbar top
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
                    }
                    
                    Spacer(minLength: 0)
                    
                    // MARK: -  images shape Count
                    if isCapturing {
                        HStack {
                            Spacer()
                            VStack(spacing: 10) {
                                ForEach(0..<4, id: \.self) { index in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white.opacity(0.6),
                                                    style: StrokeStyle(lineWidth: 2,dash: [8]))
                                            .frame(width: 60, height: 70)
                                            .background(Color.white.opacity(0.2).cornerRadius(10))
                                        
                                        if index < camera.capturedImages.count {
//                                            Image(uiImage: camera.capturedImages[index])
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: 60, height: 70)
//                                                .clipShape(RoundedRectangle(cornerRadius: 10))
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
                        .padding(.trailing, -12)
                        .padding(.top, -30)
                        
                        Spacer(minLength: 0)
                    }
                    
                    // MARK: -  count time
//                    HStack {
//                        Spacer()
//                        TextSwiftUI(title: "\(countdown)", size: 24, color: .pinkUI)
//                        Spacer()
//                    }
                    if isCapturing {
                        TextSwiftUI(title: "\(countdown)", size: 32, color: .pinkUI, weight: .bold)
                    }

                    // MARK: -  capture Button
                    Button {
                        if !isCapturing {
                            startAutoCapture()
                        } else {
                            stopAutoCapture()
                        }
                    } label: {
                        if !isFinishedCapturing {
                            Image(systemName: isCapturing ? "rectangle.ratio.4.to.3.fill" : "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                                .padding(16)
                                .background(
                                    Circle()
                                        .fill(Color.pinkUI)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 6)
                                        .padding(-3)
                                )
                        }
                    }
                    if !isFinishedCapturing {
                        TextSwiftUI(title: isCapturing ? "Tap to stop!" : "Tap to start!", color: .white)
                            .padding(10)
                            .background(Color.black.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.top, 5)
                    }
                }
                .padding(32)
                .padding(.vertical, 22)
            }
            // MARK: -  LoadingView
            if isFinishedCapturing {
                LoadingUI()
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
                UploadPhotoView(
                    images: camera.capturedImages) { newImages in
                    camera.capturedImages = newImages
                    if newImages.count < 4 {
                        isCapturing = false
                        isFinishedCapturing = false
                    }

                }
            }
        }
    }
}
// MARK: -  func
extension AutoCapture4ShotView {
    func startAutoCapture() {
        if isCapturing { return }
        isCapturing = true
        shotIndex = camera.capturedImages.count
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

            if !isCapturing {
                timer.invalidate()
                countdownTimer = nil
                return
            }

            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                countdownTimer = nil
                if !isCapturing { return }
                camera.capturePhoto()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                    if !isCapturing { return }
                    if let img = camera.capturedImage {
                        camera.capturedImages.append(img)
                    }

                    if camera.capturedImages.count < 4 && isCapturing {
                        startCountdown()
                    } else if isCapturing {

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
