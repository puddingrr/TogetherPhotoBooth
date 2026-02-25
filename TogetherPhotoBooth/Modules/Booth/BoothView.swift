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
    
    @State private var selectedLayoutIndex: Int = 0
    @State private var isSelectLayout = false
    
    var selectedLayout: LayoutModel { predefinedLayouts[selectedLayoutIndex] }
    
    var body: some View {
        ZStack(alignment: .bottom) {
                        
            VStack(spacing: 0) {
                
                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                
                ZStack(alignment: .topLeading) {
                    
                    var currentGrid: GridLayout {
                        GridLayout(
                            slotCount: selectedLayout.slots,
                            totalWidth: UIScreen.main.bounds.width,
                            totalHeight: 600
                        )
                    }
                    
                    LayoutGridView(layout: selectedLayout, capturedImages: capturedImages)

                    if currentSlotIndex < selectedLayout.slots {
                        let pos = currentGrid.position(for: currentSlotIndex)

                        CameraPreview(manager: camera)
                            .frame(width: currentGrid.slotWidth, height: currentGrid.slotHeight)
                            .cornerRadius(8)
                            .clipped()
                            .offset(
                                x: CGFloat(pos.column) * (currentGrid.slotWidth + currentGrid.spacing) + currentGrid.horizontalPadding,
                                y: CGFloat(pos.row) * (currentGrid.slotHeight + currentGrid.spacing)
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
                        isSelectLayout.toggle()
                    } label: {
                        Image(predefinedLayouts[selectedLayoutIndex].name)
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
                    .disabled(currentSlotIndex >= selectedLayout.slots)
                }
            }
            
            if isSelectLayout {
                LayoutSelectView(
                    selectedLayout: $selectedLayoutIndex,
                    isPresented: $isSelectLayout
                )
                .padding(.bottom, 70)
                .onChange(of: selectedLayoutIndex) { _ in
                    resetSession()
                }
            }
        }
        .onAppear {
            resetSession()
            camera.startSession()
        }
        .onChange(of: selectedLayoutIndex) { _ in
            resetSession()
        }
        .onChange(of: camera.capturedImage) { image in
            guard let image = image else { return }
            
            capturedImages.append(image)
            currentSlotIndex += 1
            camera.capturedImage = nil
            
            if currentSlotIndex >= selectedLayout.slots {
                goToEditor = true
            }
        }
        .navigationDestination(isPresented: $goToEditor) {
            PhotoView(
                photos: capturedImages.compactMap { $0 },
                layoutName: selectedLayout.name,
                slotCount: selectedLayout.slots
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
