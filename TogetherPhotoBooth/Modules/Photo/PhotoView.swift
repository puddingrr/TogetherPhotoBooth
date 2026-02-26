//
//  PhotoView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//

import SwiftUI
import AVFoundation

struct PhotoView: View {
    
    @ObservedObject var viewModel: PhotoBootsViewModel
    @ObservedObject var camera: CameraManager
    
    let photos: [UIImage]
    let layout: LayoutModel
    let onFinish: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State var isShowAlert: Bool = false
    
    var filteredFrames: [FrameModel] {
        frameModels.filter { $0.slots == layout.slots }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                
                ZStack(alignment: .top) {
                    let grid = layout.makeGrid(
                        totalWidth: UIScreen.main.bounds.width,
                        totalHeight: 600
                    )
                    let boothBorder: CGFloat = 6
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                    
                    VStack(spacing: boothBorder) {
                            ForEach(0..<grid.rows, id: \.self) { row in
                                HStack(spacing: boothBorder) {
                                    ForEach(0..<grid.columns, id: \.self) { column in
                                        let index = row * grid.columns + column
                                        
                                        if index < layout.slots {
                                            if let image = photos[safe: index] {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(
                                                        width: grid.slotWidth - boothBorder,
                                                        height: grid.slotHeight - boothBorder
                                                    )
                                                    .clipped()
                                                    .cornerRadius(6)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(12)
                        .frame(
                            width: UIScreen.main.bounds.width,
                            height: grid.totalHeight
                        )
                    
                    Color.white.opacity(0.1)
                    
                    // Image Frame Overlay
                    if let index = viewModel.selectedFrameIndex,
                       filteredFrames.indices.contains(index) {
                        
                        Image(filteredFrames[index].name)
                            .resizable()
                            .frame(
                                width: UIScreen.main.bounds.width,
                                height: grid.totalHeight
                            )
                    }
                    
                    // Button Edit photos
                    CustomButtonEditPhotoView(isShowAlert: $isShowAlert)
                }
                .padding(.horizontal, 12)
                .frame(height: 600)
                .padding(.top, 12)
                
                Spacer()
                
                HStack {
                    selectFrameBoton
                    Spacer()
                    downloadButto
                }
                .padding()
            }
            if viewModel.isSelectFrame {
                FrameSelectView(
                    frames: filteredFrames,
                    selectedFrame: $viewModel.selectedFrameIndex
                )
                .padding(.bottom, 70)
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $viewModel.showStickerSheet) {
        }
    }
}

extension PhotoView {
    var downloadButto: some View {
        Button {
            Utilize.shared.showAlertWithButton(title: "DownLoad", message: "Save Photo to your gallery?") { btn in
                if btn == 1 {
                    saveImage {
                        viewModel.selectedFrameIndex = nil
                        dismiss()
                        onFinish()
                    }
                } else {
                    dismiss()
                    onFinish()
                    viewModel.selectedFrameIndex = nil
                }
            }
        } label: {
            Text("Download")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.greenDark.cornerRadius(5))
        }
    }
    
    var selectFrameBoton: some View {
        Button {
            viewModel.isSelectFrame.toggle()
        } label: {
            Image(.frameBTN)
                .resizable()
                .padding(4)
                .frame(width: 40, height: 40)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.greenDark, lineWidth: 2)
                )
        }
    }
    
    func saveImage(completion: @escaping () -> Void) {
        camera.startSession()
        
        let grid = layout.makeGrid(
            totalWidth: UIScreen.main.bounds.width,
            totalHeight: 600
        )
        
        let renderer = ImageRenderer(content:
                                        ZStack {
            VStack(spacing: grid.spacing) {
                ForEach(0..<grid.rows, id: \.self) { row in
                    HStack(spacing: grid.spacing) {
                        ForEach(0..<grid.columns, id: \.self) { col in
                            let index = row * grid.columns + col
                            if index < layout.slots, let img = photos[safe: index] {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: grid.slotWidth, height: grid.slotHeight)
                                    .clipped()
                                    .cornerRadius(8)
                            } else {
                                Spacer()
                                    .frame(width: grid.slotWidth, height: grid.slotHeight)
                            }
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: grid.totalHeight)
            .padding(.horizontal, grid.horizontalPadding)
            
            ForEach(viewModel.stickers, id: \.self) { sticker in
                Image(uiImage: sticker)
            }
            
            if let index = viewModel.selectedFrameIndex {
                Image(frameModels[index].name)
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 8)
                    .clipped()
            }
            
            Color.white.opacity(0.1)
        }
        )
        
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        }
        
        DispatchQueue.main.async {
            camera.stopSession()
            completion()
        }
    }
}
