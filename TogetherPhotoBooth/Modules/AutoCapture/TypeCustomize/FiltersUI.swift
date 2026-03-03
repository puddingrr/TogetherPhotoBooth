//
//  FiltersUI.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 3/2/26.
//

import SwiftUI

struct FilterCategory {
    let color: Color
    let title: String
    let icon: UIImage
}

struct FiltersUI: View {
    
    @State private var selectedIndex: Int? = nil

    let categories: [FilterCategory] = [
        .init(color: .blue, title: "Blue Colo", icon: .cat),
        .init(color: .red, title: "Red", icon: .cat),
        .init(color: .green, title: "Green", icon: .cat),
        .init(color: .yellow, title: "Yellow", icon: .cat)
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible())].repeated(count: 3), spacing: 6) {
                
                ForEach(categories.indices, id: \.self) { index in
                    VStack(spacing: 8) {
                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.white)
                                .frame(width: 115, height: 115)
                                .overlay {
                                    Image(uiImage: categories[index].icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                            
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
