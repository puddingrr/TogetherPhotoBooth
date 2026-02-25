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
                
                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                
                ZStack(alignment: .topLeading) {
                    
                    let grid = GridLayout(
                        slotCount: selectedFrameModel.slots,
                        totalWidth: UIScreen.main.bounds.width,
                        totalHeight: 600
                    )
                    
                    LayoutGridView(layout: selectedFrameModel, capturedImages: capturedImages)

                    if currentSlotIndex < selectedFrameModel.slots {
                        let pos = grid.position(for: currentSlotIndex)
                        
                        CameraPreview(manager: camera)
                            .frame(width: grid.slotWidth, height: grid.slotHeight)
                            .cornerRadius(8)
                            .clipped()
                            .offset(
                                x: CGFloat(pos.column) * (grid.slotWidth + grid.spacing) + grid.horizontalPadding,
                                y: CGFloat(pos.row) * (grid.slotHeight + grid.spacing)
                            )
                            .animation(.easeInOut(duration: 0.3), value: currentSlotIndex)
                    }
                    
                    Color.white.opacity(0.1)
                }
                .frame(height: 600)
                .padding(.top, 12)
                
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
                LayoutSelectView(
                    selectedLayout: Binding(
                        get: { frameModels[selectedFrameIndex] },
                        set: { newValue in
                            if let newIndex = frameModels.firstIndex(where: { $0.id == newValue.id }) {
                                selectedFrameIndex = newIndex
                                resetSession()
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
