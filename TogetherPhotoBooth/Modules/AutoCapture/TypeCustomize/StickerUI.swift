//
//  StickerUI.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 3/2/26.
//

import SwiftUI

struct StickerCategory {
    let title: String
    let stickers: [String]
}

struct StickerItem: Identifiable {
    let id = UUID()
    var emoji: String
    var parentImageIndex: Int? = nil
    var position: CGPoint
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
}

struct StickerUI: View {
    
    @Binding var selectedStickers: [StickerItem]
    @State private var selectedSticker: Int? = nil

    let categories: [StickerCategory] = [
        
        .init(title: "Love", stickers: ["💕","💘","💋","💌","💍","🌹","🫶","💖","🧸","🩷"]),
        .init(title: "Cute Animals", stickers: [ "🐱","🐰","🐻","🐼","🐶","🐹","🐥","🐸","🐨","🦊"]),
        .init(title: "Aesthetic", stickers: ["✨","⭐","🌙","☁️","🌈","💫","🔮","🪩","🕯","🦋"]),
        .init(title: "Kawaii", stickers: ["🎀","🍓","🧁","🍒","🧃","💄","🪞","🎧","💅","🧴"]),
        .init(title: "Party", stickers: ["🎂","🎉","🎈","🥳","🎁", "🕯","🍰","🪅","🍾","🧨"]),
        .init(title: "Photo Booth", stickers: ["📷","🎞","🖼","🧡","🕶","👑","🧢","💬","📍","🏷"])
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                VStack {
                    TextSwiftUI(title: "✨ Tab sticker to add theme!", size: 16, color: Color(hex: "9A537C").opacity(0.5), weight: .bold)
                    TextSwiftUI(title: "\(selectedStickers.count) stickers added", size: 14, color: .gray)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.pinkBgGredient.opacity(0.5))
                .cornerRadius(12)
            
                ForEach(0..<categories.count, id: \.self) { c in
                    VStack(alignment: .leading, spacing: 12) {
                        TextSwiftUI(title: categories[c].title, size: 16, color: .black, weight: .bold)
                        LazyVGrid(columns: [GridItem(.flexible())].repeated(count: 5), spacing: 12) {
                            ForEach(0..<categories[c].stickers.count, id: \.self) { i in
                                let img = categories[c].stickers[i]
                                let isSelected = selectedStickers.contains { $0.emoji == img }

                                Text("\(img)")
                                    .font(.system(size: 40))
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(isSelected ? Color.pink.opacity(0.5) : Color.white)
                                    )
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                                    .onTapGesture {
                                        if let index = selectedStickers.firstIndex(where: { $0.emoji == img }) {
                                            // Remove sticker if already added
                                            selectedStickers.remove(at: index)
                                        } else {
                                            // Add new sticker at default position (center)
                                            let newSticker = StickerItem(
                                                emoji: img,
                                                parentImageIndex: i,
                                                position: CGPoint(x: 200, y: 200)
                                            )
                                            selectedStickers.append(newSticker)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
        }
    }
}
