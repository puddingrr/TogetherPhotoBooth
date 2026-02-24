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
    let frameName: String
    let onFinish: () -> Void
    
    @State private var stickers: [UIImage] = []
    
    @Environment(\.dismiss) private var dismiss
    @State private var showSavedAlert = false
    
    @State private var showTextEditor = false
    @State private var newText: String = ""
    @State private var showStickerSheet = false
    @State private var showPhotoPicker = false
    @State private var drawingEnabled = false
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    if let firstPhoto = photos.first {
                        Image(uiImage: firstPhoto)
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(
                                UIImage(named: frameName)!.size,
                                contentMode: .fit
                            )
                            .cornerRadius(10)
                            .clipped()
                            .padding(10)
                    }
                    
                    Image(frameName)
                        .resizable()
                        .offset()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(10)
                        .clipped()
                    
                    ForEach(stickers, id: \.self) { sticker in
                        StickerView(image: sticker) // your draggable StickerView
                    }
                    
                    // Text overlay
                    if showTextEditor {
                        TextField("Enter text", text: $newText, onCommit: {
                            // Add text as sticker image or just keep as overlay
                            stickers.append(textToImage(newText))
                            newText = ""
                            showTextEditor = false
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                    }
                    
                    // Drawing overlay
                    if drawingEnabled {
                        DrawingCanvasView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)
                    }
                }
            }
            
            HStack {
                HStack(spacing: 8) {
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
            .padding(.top, 10)
        }
        .padding(16)
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK") {
                dismiss() // go back to BoothView
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
        let renderer = ImageRenderer(content:
        ZStack {
            if let firstPhoto = photos.first {
                Image(uiImage: firstPhoto)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(
                        UIImage(named: frameName)!.size,
                        contentMode: .fit
                    )
                    .cornerRadius(10)
                    .clipped()
                    .padding(10)
            }
            
            Image(frameName)
                .resizable()
                .offset()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(10)
                .clipped()
            
            ForEach(stickers, id: \.self) { sticker in
                Image(uiImage: sticker)
            }
        }
        )
        
        if let uiImage = renderer.uiImage {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        }
        camera.session.startRunning()
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
