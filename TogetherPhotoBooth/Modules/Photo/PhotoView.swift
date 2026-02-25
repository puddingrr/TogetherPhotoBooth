//
//  PhotoView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//

import SwiftUI
import AVFoundation

struct PhotoView: View {
    
    @StateObject private var camera = CameraManager()
    
    let photos: [UIImage]
    let layoutName: String
    let slotCount: Int
    let onFinish: () -> Void
    
    @State private var stickers: [UIImage] = []
    
    @Environment(\.dismiss) private var dismiss
    @State private var showSavedAlert = false
    
    @State private var showTextEditor = false
    @State private var newText: String = ""
    @State private var showStickerSheet = false
    @State private var showPhotoPicker = false
    @State private var drawingEnabled = false
    
    @State private var selectedFrameIndex: Int = 0
    @State private var isSelectFrame = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                
                ZStack(alignment: .top) {
                    let grid = GridLayout(
                        slotCount: slotCount,
                        totalWidth: UIScreen.main.bounds.width,
                        totalHeight: 600
                    )

                    VStack(spacing: grid.spacing) {
                        ForEach(0..<grid.rows, id: \.self) { row in
                            HStack(spacing: grid.spacing) {
                                ForEach(0..<grid.columns, id: \.self) { column in
                                    let index = row * grid.columns + column
                                    
                                    if index < slotCount {
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
                    
                    Image(layoutName)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.horizontal, 8)
                        .clipped()
                    
                    ForEach(stickers, id: \.self) { sticker in
                        StickerView(image: sticker)
                    }
                    
                    if showTextEditor {
                        TextField("Enter text", text: $newText, onCommit: {
                            stickers.append(textToImage(newText))
                            newText = ""
                            showTextEditor = false
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                    }
                    
                    if drawingEnabled {
                        DrawingCanvasView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)
                    }
                    
                    HStack(alignment: .top) {
                        Spacer()
                        VStack(spacing: 8) {
                            ForEach(PhotoAction.allCases) { action in
                                Button {
                                    handleAction(action)
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
                    
                    Button {
                        saveImage()
                        showSavedAlert = true
                    } label: {
                        Text("Download")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.green.cornerRadius(10))
                    }
                }
                .padding()
            }
            if isSelectFrame {
                FrameSelectView(
                    selectedFrame: Binding(
                        get: { frameModels[selectedFrameIndex] },
                        set: { newValue in
                            if let newIndex = frameModels.firstIndex(where: { $0.id == newValue.id }) {
                                selectedFrameIndex = newIndex
                            }
                        }
                    ),
                    isPresented: $isSelectFrame
                )
                .padding(.bottom, 60)
            }
        }
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK") {
                dismiss()
                onFinish()
            }
        } message: {
            Text("Your photo has been saved to your gallery 💖")
        }
        .sheet(isPresented: $showStickerSheet) {
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
                                        stickers.append(img)
                                    }
                                    showStickerSheet = false
                                }
                        }
                    }
                    .padding()
                }
                Button("Close") { showStickerSheet = false }
                    .padding()
            }
        }
    }
}

extension PhotoView {
    func handleAction(_ action: PhotoAction) {
        switch action {
        case .text:
            showTextEditor = true
        case .sticker:
            showStickerSheet = true
        case .draw:
            drawingEnabled.toggle()
        case .image:
            showPhotoPicker = true
        }
    }
    func saveImage() {
        camera.session.stopRunning()
        
        let grid = GridLayout(
            slotCount: slotCount,
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
                                if index < slotCount, let img = photos[safe: index] {
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
                
                // Overlay stickers
                ForEach(stickers, id: \.self) { sticker in
                    Image(uiImage: sticker)
                }
                
                // Overlay frame image
                if let frameImage = UIImage(named: layoutName) {
                    Image(uiImage: frameImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: grid.totalHeight)
                        .clipped()
                }
            }
        )
        
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        }
        DispatchQueue.main.async {
            camera.session.startRunning()
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
