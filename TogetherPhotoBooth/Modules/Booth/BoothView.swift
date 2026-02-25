//
//  ContentView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//

import SwiftUI

struct BoothView: View {
    
    @StateObject private var camera = CameraManager()
    
    @State private var capturedImages: [UIImage] = []
    @State private var currentSlotIndex = 0
    @State private var goToEditor = false
    
    @State private var selectedFrameIndex: Int = 0
    @State private var isSelectFrame = false
    
    var selectedFrameModel: FrameModel {
        frameModels[selectedFrameIndex]
    }
    
    var cameraScale: CGFloat {
        1 / CGFloat(selectedFrameModel.slots)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        isSelectFrame.toggle()
                    } label: {
                        Image(frameModels[selectedFrameIndex].name)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 3)
                            )
                    }
                    Spacer()
                    
                    if !capturedImages.isEmpty {
                        Button {
                            resetSession()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding(12)
                
                ZStack(alignment: .top) {
                    
                    let slotCount = selectedFrameModel.slots
                    let totalHeight: CGFloat = 500
                    let slotHeight = totalHeight / CGFloat(slotCount) - 16
                    
                    VStack(spacing: 16) {
                        ForEach(0..<slotCount, id: \.self) { index in
                            
                            if index < capturedImages.count {
                                Image(uiImage: capturedImages[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: slotHeight)
                                    .clipped()
                            } else {
                                Color.clear
                                    .frame(height: slotHeight)
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.all, 32)
                    
                    if currentSlotIndex < slotCount {
                        CameraPreview(manager: camera)
                            .frame(height: slotHeight)
                            .clipped()
                            .offset(y: CGFloat(currentSlotIndex) * slotHeight + 16 * CGFloat(currentSlotIndex))
                            .animation(.easeInOut(duration: 0.3), value: currentSlotIndex)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.red, lineWidth: 3)
                            )
                            .padding(.all, 32)
                    }
                    
                    Image(selectedFrameModel.name)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 16)
                        .clipped()
                    
                }
                .frame(height: 600)
                .padding(.top, 16)
                
                Spacer()
                
                HStack {
                    Button {
                        isSelectFrame.toggle()
                    } label: {
                        Image(frameModels[selectedFrameIndex].name)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 3)
                            )
                    }
                    Spacer()
                    
                    if !capturedImages.isEmpty {
                        Button {
                            resetSession()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
                .padding()
                .overlay {
                    Button {
                        camera.capturePhoto()
                    } label: {
                        Image("captureBotton")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                    }
                    .disabled(currentSlotIndex >= selectedFrameModel.slots)
                }
            }
            
            if isSelectFrame {
                FrameSelectView(
                    selectedFrame: Binding(
                        get: { frameModels[selectedFrameIndex].name },
                        set: { newValue in
                            if let newIndex = frameModels.firstIndex(where: { $0.name == newValue }) {
                                selectedFrameIndex = newIndex
                                capturedImages = []
                                currentSlotIndex = 0
                            }
                        }
                    ),
                    isPresented: $isSelectFrame
                )
                .padding(.bottom, 70)
            }
        }
        .onAppear {
            resetSession()
            camera.startSession()
        }
        .onChange(of: selectedFrameIndex) { _ in
            resetSession()
        }
        .onChange(of: camera.capturedImage) { image in
            guard let image = image else { return }
            
            capturedImages.append(image)
            currentSlotIndex += 1
            camera.capturedImage = nil
            
            if currentSlotIndex >= selectedFrameModel.slots {
                goToEditor = true
            }
        }
        .navigationDestination(isPresented: $goToEditor) {
            PhotoView(
                photos: capturedImages.compactMap { $0 },
                frameName: selectedFrameModel.name,
                slotCount: selectedFrameModel.slots
            ) {
                resetSession()
                camera.startSession()
            }
        }
        .onDisappear {
            camera.stopSession()
        }
    }
    private func resetSession() {
        capturedImages = []
        currentSlotIndex = 0
    }
}
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
