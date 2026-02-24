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
