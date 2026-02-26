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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
                        
            VStack(spacing: 0) {
                
                Image(.appLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .onTapGesture {
                        dismiss()
                    }
                
                ZStack(alignment: .topLeading) {
                    
                    var currentGrid: GridLayout {
                        GridLayout(
                            layout: selectedLayout,
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
                
                HStack(alignment: .bottom) {
                    Button {
                        viewModel.isSelectLayout.toggle()
                    } label: {
                        VStack(spacing: 3) {
                            LayoutPreviewView(layout: predefinedLayouts[viewModel.selectedLayoutIndex])
                                .frame(width: 35, height: 35)
                                .padding(6)
                                .background(Color.white)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray ,lineWidth: 2)
                                )
                            
                            Text((viewModel.selectedLayoutIndex != 0) ? predefinedLayouts[viewModel.selectedLayoutIndex].name : "Frame")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
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
                viewModel: viewModel, camera: camera,
                photos: viewModel.capturedImages.compactMap { $0 },
                layout: selectedLayout
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
