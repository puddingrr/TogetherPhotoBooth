//
//  ContentView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//

import SwiftUI

struct BoothView: View {
    
    @StateObject var viewModel = PhotoBootsViewModel()
    @StateObject var camera = CameraManager()
    
    @State var goToEditor = false
    
    var selectedLayout: LayoutModel { predefinedLayouts[viewModel.selectedLayoutIndex] }
    
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
                    
                    LayoutGridView(layout: selectedLayout, capturedImages: viewModel.capturedImages)

                    if viewModel.currentSlotIndex < selectedLayout.slots {
                        let pos = currentGrid.position(for: viewModel.currentSlotIndex)

                        CameraPreview(manager: camera)
                            .frame(width: currentGrid.slotWidth, height: currentGrid.slotHeight)
                            .cornerRadius(8)
                            .clipped()
                            .offset(
                                x: CGFloat(pos.column) * (currentGrid.slotWidth + currentGrid.spacing) + currentGrid.horizontalPadding,
                                y: CGFloat(pos.row) * (currentGrid.slotHeight + currentGrid.spacing)
                            )
                            .animation(.easeInOut(duration: 0.3), value: viewModel.currentSlotIndex)
                    }
                    
                    Color.white.opacity(0.1)
                }
                .frame(height: 600)
                .padding(.top, 12)
                
                Spacer()
                
                HStack {
                    Button {
                        viewModel.isSelectLayout.toggle()
                    } label: {
                        Image(predefinedLayouts[viewModel.selectedLayoutIndex].name)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 3)
                            )
                    }
                    Spacer()
                    
                    if !viewModel.capturedImages.isEmpty {
                        Button {
                            viewModel.resetSession()
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
                    .disabled(viewModel.currentSlotIndex >= selectedLayout.slots)
                }
            }
            
            if viewModel.isSelectLayout {
                LayoutSelectView(
                    selectedLayout: $viewModel.selectedLayoutIndex,
                    isPresented: $viewModel.isSelectLayout
                )
                .padding(.bottom, 70)
                .onChange(of: viewModel.selectedLayoutIndex) { _ in
                    viewModel.resetSession()
                }
            }
        }
        .onAppear {
            viewModel.resetSession()
            camera.startSession()
        }
        .onChange(of: viewModel.selectedLayoutIndex) { _ in
            viewModel.resetSession()
        }
        .onChange(of: camera.capturedImage) { image in
            guard let image = image else { return }
            
            viewModel.capturedImages.append(image)
            viewModel.currentSlotIndex += 1
            camera.capturedImage = nil
            
            if viewModel.currentSlotIndex >= selectedLayout.slots {
                goToEditor = true
            }
        }
        .navigationDestination(isPresented: $goToEditor) {
            PhotoView(
                viewModel: viewModel,
                photos: viewModel.capturedImages.compactMap { $0 },
                layoutName: selectedLayout.name,
                slotCount: selectedLayout.slots
            ) {
                viewModel.resetSession()
                camera.startSession()
            }
        }
        .onDisappear {
            camera.stopSession()
        }
        .navigationBarBackButtonHidden(true)
    }
}
