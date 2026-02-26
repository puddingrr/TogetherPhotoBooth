//
//  CustomButtonEditPhotoView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/26/26.
//

import SwiftUI

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

struct CustomButtonEditPhotoView: View {
    @Binding var isShowAlert: Bool
    var body: some View {
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

}

struct TextEditPhotoView: View {
    var text: String
    var body: some View {
        VStack {
            // no idea yet
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
