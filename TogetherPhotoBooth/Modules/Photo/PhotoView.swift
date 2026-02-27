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
    @State var selectedFrameColor: UIFrameColor? = nil
    @State var isSelectedFrameColor: Bool = false
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                
                // MARK: Booth + Header
                let outerPadding: CGFloat = 12
                let boothBorder: CGFloat = 6
                let topInset: CGFloat = 30 // space inside booth
                let screenWidth = UIScreen.main.bounds.width
                let boothWidth = screenWidth - (outerPadding * 2)
                let boothHeight = boothWidth * 1.7

                ZStack(alignment: .top) {

                    // Booth background / border
                    RoundedRectangle(cornerRadius: 5)
                        .fill(selectedFrameColor?.color.opacity(0.3) ?? Color.gray.opacity(0.1))
                    
                    VStack(spacing: boothBorder) {
                        // top space inside booth
                        Spacer().frame(height: topInset)

                        // Image grid
                        let grid = layout.makeGrid(
                            totalWidth: boothWidth,
                            totalHeight: boothHeight - topInset // reduce height for images
                        )
                        
                        VStack(spacing: boothBorder) {
                            ForEach(0..<grid.rows, id: \.self) { row in
                                HStack(spacing: boothBorder) {
                                    ForEach(0..<grid.columns, id: \.self) { column in
                                        let index = row * grid.columns + column
                                        
                                        if index < layout.slots, let image = photos[safe: index] {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: grid.slotWidth, height: grid.slotHeight)
                                                .clipped()
                                                .cornerRadius(6)
                                        } else {
                                            Spacer()
                                                .frame(width: grid.slotWidth, height: grid.slotHeight)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(outerPadding)
                    }
                    Color.white.opacity(0.1)
                    
                    // Button Edit photos
                    CustomButtonEditPhotoView(isShowAlert: $isShowAlert)
                        .padding(.top, 36)
                    
                    // Text inside booth
                    HStack {
                        Text("Together x Boots")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.leading, 12)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .frame(height: topInset)
                }
                .frame(width: boothWidth, height: boothHeight)
                .padding(.horizontal, outerPadding)
                .padding(.top, 22)
                
                Spacer(minLength: 0)
                
                HStack {
                    selectFrameButon
                    selectColorFrameButon
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
            if isSelectedFrameColor {
                selectedColorUIView
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
    
    var selectFrameButon: some View {
        Button {
            viewModel.isSelectFrame.toggle()
            if viewModel.isSelectFrame {
                isSelectedFrameColor = false
            }
        } label: {
            VStack {
                Image(.frameBTN)
                    .resizable()
                    .padding(4)
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.greenDark, lineWidth: 2)
                    )
                Text("Frame")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var selectColorFrameButon: some View {
        Button {
            isSelectedFrameColor.toggle()
            if isSelectedFrameColor {
                viewModel.isSelectFrame = false
            }
        } label: {
            VStack {
                Image(.frameBTN)
                    .resizable()
                    .padding(4)
                    .frame(width: 40, height: 40)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.greenDark, lineWidth: 2)
                    )
                Text("Color")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var selectedColorUIView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(UIFrameColor.allCases, id: \.self) { item in
                    Circle()
                        .fill(item.color)
                        .frame(width: 30, height: 30)
                        .overlay(
                            ZStack {
                                // Outer highlight ring
                                Circle()
                                    .stroke(selectedFrameColor == item ? item.color : Color.clear, lineWidth: 3)
                                    .frame(width: 40, height: 40)
                                
                                // Inner white ring
                                Circle()
                                    .stroke(selectedFrameColor == item ? item.color : Color.clear, lineWidth: 2)
                            }
                        )
                        .contentShape(Circle()) // better tap area
                        .onTapGesture {
                            selectedFrameColor = (selectedFrameColor == item) ? nil : item
                        }
                }
            }
            .padding(16)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(.gray, lineWidth: 2)
//            )
        }
        .padding(.bottom, 100)
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
