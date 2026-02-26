//
//  DragStickerView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//

import SwiftUI

struct StickerView: View {
    
    let image: UIImage
    
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 100, height: 100)
            .scaleEffect(scale)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in offset = value.translation }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in scale = value }
            )
    }
}

struct CustomSheetSelectSticker: View {
    @Binding var showStickerSheet: Bool
    @Binding var stickers: [UIImage]
    var body: some View {
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
