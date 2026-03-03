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
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    @State private var selectedIndex: Int? = nil
    
    let categories: [ColorCategory] = [
        ColorCategory(color: .blue, title: "Blue"),
        ColorCategory(color: .red, title: "Red"),
        ColorCategory(color: .green, title: "Green"),
        ColorCategory(color: .yellow, title: "Yellow"),
        ColorCategory(color: .blue, title: "Blue"),
        ColorCategory(color: .red, title: "Red"),
        ColorCategory(color: .green, title: "Green"),
        ColorCategory(color: .yellow, title: "Yellow")
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 6) {
                
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
                        selectedIndex = index
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
}
