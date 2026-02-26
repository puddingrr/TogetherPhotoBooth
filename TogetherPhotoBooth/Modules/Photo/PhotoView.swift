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
    @StateObject private var camera = CameraManager()
    
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
                    
                    VStack(spacing: grid.spacing) {
                        ForEach(0..<grid.rows, id: \.self) { row in
                            HStack(spacing: grid.spacing) {
                                ForEach(0..<grid.columns, id: \.self) { column in
                                    let index = row * grid.columns + column
                                    
                                    if index < layout.slots {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.1))
                                            
                                            if let image = photos[safe: index] {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: grid.slotWidth, height: grid.slotHeight)
                                                    .clipped()
                                            }
                                        }
                                        .frame(width: grid.slotWidth, height: grid.slotHeight)
                                        .cornerRadius(8)
                                    } else {
                                        Spacer()
                                            .frame(width: grid.slotWidth, height: grid.slotHeight)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: grid.totalHeight)
                    .padding(.horizontal, grid.horizontalPadding)
                    
                    Color.white.opacity(0.1)
                    
                    if let index = viewModel.selectedFrameIndex,
                       filteredFrames.indices.contains(index) {
                        
                        Image(filteredFrames[index].name)
                            .resizable()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.horizontal, 8)
                            .clipped()
                    }
                    
                    HStack(alignment: .top) {
                        Spacer()
                        VStack(spacing: 8) {
                            ForEach(PhotoAction.allCases) { action in
                                Button {
                                    Utilize.shared.showAlertWithButton(
                                        title: "Opps!!!",
                                        message: "Coming Soon...."
                                    ) { _ in
                                        isShowAlert = false
                                    }
                                } label: {
                                    Image(systemName: action.iconName)
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    .padding(16)
                }
                .frame(height: 600)
                .padding(.top, 12)
                
                Spacer()
                
                HStack {
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
                    
                    Spacer()
                    
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
            VStack {
                Text("Select a sticker").font(.headline).padding()
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(["sticker1","sticker2","sticker3"], id: \.self) { name in
                            Image(name)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .onTapGesture {
                                    if let img = UIImage(named: name) {
                                        viewModel.stickers.append(img)
                                    }
                                    viewModel.showStickerSheet = false
                                }
                        }
                    }
                    .padding()
                }
                Button("Close") { viewModel.showStickerSheet = false }
                    .padding()
            }
        }
    }
}

extension PhotoView {
    func handleAction(_ action: PhotoAction) {
        switch action {
        case .text:
            isShowAlert = true
            //            viewModel.showTextEditor = true
        case .sticker:
            isShowAlert = true
            //            viewModel.showStickerSheet = true
        case .draw:
            isShowAlert = true
            //            viewModel.drawingEnabled.toggle()
        case .image:
            isShowAlert = true
            //            viewModel.showPhotoPicker = true
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
    func textToImage(_ text: String) -> UIImage {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .clear
        label.sizeToFit()
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}

enum PhotoAction: CaseIterable, Identifiable {
    case text, sticker, draw, image
    
    var id: String { "\(self)" }
    
    var iconName: String {
        switch self {
        case .text: return "textformat.alt"
        case .sticker: return "face.smiling"
        case .draw: return "scribble.variable"
        case .image: return "photo.on.rectangle"
        }
    }
}

struct DrawingCanvasView: View {
    @State private var paths: [Path] = []
    @State private var currentPath = Path()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Draw existing paths
                ForEach(paths.indices, id: \.self) { i in
                    paths[i]
                        .stroke(Color.red, lineWidth: 4)
                }
                
                // Draw current path
                currentPath.stroke(Color.red, lineWidth: 4)
            }
            .background(Color.clear)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        currentPath.move(to: value.location)
                        currentPath.addLine(to: value.location)
                    }
                    .onEnded { _ in
                        paths.append(currentPath)
                        currentPath = Path()
                    }
            )
        }
    }
}
