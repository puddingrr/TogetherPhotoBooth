//
//  StickerUI.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 3/2/26.
//

import SwiftUI

struct StickerUI: View {
    let image: [UIImage] = [.cat].repeated(count: 10)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack {
                    TextSwiftUI(title: "✨ Tab sticker to add theme!", size: 16, color: Color(hex: "9A537C").opacity(0.5), weight: .bold)
                    TextSwiftUI(title: "0 stickers added", size: 14, color: .gray)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.pinkBgGredient.opacity(0.5))
                .cornerRadius(12)
            
                LazyVGrid(columns: [GridItem(.flexible())].repeated(count: 5), spacing: 16) {
                    ForEach(image.indices, id: \.self) { i in
                        Image(uiImage: image[i])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.white)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                    }
                }
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 6, trailing: 0))
        }
    }
}
