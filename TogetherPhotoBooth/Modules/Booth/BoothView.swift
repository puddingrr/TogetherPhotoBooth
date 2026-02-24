//
//  ContentView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//

import AVFoundation
import SwiftUI

struct BoothView: View {
    
    @StateObject private var camera = CameraManager()
    
    @State private var capturedImages: [UIImage?] = [nil, nil, nil]
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
        VStack {
            VStack {
                ZStack(alignment: .bottom) {
                    CameraPreview(manager: camera)
                        .cornerRadius(10)
                        .clipped()
                        .padding(10)
                    
                    Image(selectedFrameModel.name)
                        .resizable()
                        .offset()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(10)
                        .clipped()
                    
                    if isSelectFrame {
                        FrameSelectView(
                            selectedFrame: Binding(
                                get: { frameModels[selectedFrameIndex].name },
                                set: { newValue in
                                    if let newIndex = frameModels.firstIndex(where: { $0.name == newValue }) {
                                        selectedFrameIndex = newIndex
                                        capturedImages = [nil, nil, nil]
                                        currentSlotIndex = 0
                                    }
                                }
                            ),
                            isPresented: $isSelectFrame
                        )
                    }
                }
            }
            
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
                
                if capturedImages.isEmpty {
                    Button {
                        capturedImages = [nil, nil, nil]
                        currentSlotIndex = 0
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
            }
        }
        .padding(16)
        .onChange(of: camera.capturedImage) { image in
            guard let image = image else { return }
            
            capturedImages[currentSlotIndex] = image
            currentSlotIndex += 1
            camera.capturedImage = nil
            
            if currentSlotIndex >= selectedFrameModel.slots {
                goToEditor = true
            }
        }
        .navigationDestination(isPresented: $goToEditor) {
            PhotoView(
                photos: capturedImages.compactMap { $0 },
                frameName: selectedFrameModel.name
            ) {
                capturedImages = [nil, nil, nil]
                currentSlotIndex = 0
                camera.session.startRunning()
            }
        }
    }
}
