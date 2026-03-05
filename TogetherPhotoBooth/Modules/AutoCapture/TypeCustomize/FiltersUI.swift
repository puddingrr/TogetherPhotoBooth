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
    let icon: String
}

struct FiltersUI: View {
    
    @Binding var selectedFilter: Color
    @State private var selectedIndex: Int? = nil
    
    let categories: [FilterCategory] = [
        .init(color: Color(hex: "6CA0DC"), title: "Soft Blue", icon: "snowflake"),
        .init(color: Color(hex: "E07A5F"), title: "Old Money", icon: "crown.fill"),
        .init(color: Color(hex: "F8C8DC"), title: "Soft Girl", icon: "sparkles"),
        .init(color: Color(hex: "F4A261"), title: "Golden Hour", icon: "sun.max.fill")
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
                                    Image(systemName: categories[index].icon)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(categories[index].color)
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
                        selectedFilter = categories[index].color
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
}
