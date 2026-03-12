//
//  BackgorundUI.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 3/2/26.
//

import SwiftUI

import SwiftUI

struct ColorCategory {
    let color: Color
    let title: String
}

struct BackgroundUI: View {
    
    @Binding var selectedBackground: Color
    @State private var selectedIndex: Int? = nil

    let categories: [ColorCategory] = [
        ColorCategory(color: Color(hex: "EBDBE8"), title: "Pink"),
        ColorCategory(color: Color(hex: "F9EBEB"), title: "Peach"),
        ColorCategory(color: Color(hex: "f8c6d8"), title: "Pink Blush"),
        ColorCategory(color: Color(hex: "f9d2b3"), title: "Peach Blush"),
        ColorCategory(color: Color(hex: "FFF2D0"), title: "Yellow"),
        ColorCategory(color: Color(hex: "d5c6e0"), title: "Lavender"),
        ColorCategory(color: Color(hex: "ffddd2"), title: "Pearl"),
        ColorCategory(color: Color(hex: "fcd5ce"), title: "Pastel"),
        ColorCategory(color: Color(hex: "d8f3dc"), title: "Soft Teal"),
        ColorCategory(color: Color(hex: "A8F1FF"), title: "Sky Blue"),
        ColorCategory(color: Color(hex: "C7EABB"), title: "Green"),
        ColorCategory(color: Color(hex: "F9EBEB"), title: "Soft Pink"),
        ColorCategory(color: Color(hex: "C9BEFF"), title: "Purple"),
        ColorCategory(color: Color(hex: "91ADC8"), title: "Teal")
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible())].repeated(count: 3), spacing: 6) {
                
                ForEach(categories.indices, id: \.self) { index in
                    VStack(spacing: 6) {
                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(categories[index].color)
                                .frame(width: 85, height: 85)
                            
                            if selectedIndex == index {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .background(
                                        Circle()
                                            .fill(Color.pinkUI)
                                            .frame(width: 20, height: 20)
                                    )
                                    .padding(10)
                            }
                        }
                        
                        TextSwiftUI(title: categories[index].title, size: 14, color: .gray)
                    }
                    .onTapGesture {
                        if selectedIndex == index {
                            selectedIndex = nil
                            selectedBackground = .white
                        } else {
                            selectedIndex = index
                            selectedBackground = categories[index].color
                        }
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
}
