//
//  CustomTab.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 3/2/26.
//

import SwiftUI

struct CustomTabView: View {
    @Binding var index: Int
    var items: [CustomUIModel]
    @Namespace private var animation

    var body: some View {
        
        HStack(spacing: 0) {
            ForEach(0..<items.count, id: \.self) { i in
                Button {
                    withAnimation(.easeInOut) {
                        index = i
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: items[i].icon)
                            .resizable()
                            .foregroundColor(index == i ? items[i].color : .gray)
                            .frame(width: 20, height: 20)
                        TextSwiftUI(title: items[i].title, size: 13,
                                    color: index == i ? items[i].color : .gray, weight: .bold)
                    }
                    .padding(EdgeInsets(top: 12, leading: 9, bottom: 12, trailing: 9))
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            if index == i {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(items[i].background)
                            }
                        }
                    )
                }
            }
        }
    }
}

struct CustomUIModel {
    var icon: String
    var title: String
    var color: Color
    var background: Color
}
