//
//  LayoutView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/25/26.
//
import SwiftUI

struct LayoutModel {
    let name: String
    let slots: Int
    let style: LayoutStyle
}

enum LayoutStyle {
    case vertical
    case horizontal
    case grid(columns: Int)
    case custom
}

let predefinedLayouts: [LayoutModel] = [
    .init(name: "1 Photo", slots: 1, style: .vertical),
    .init(name: "2 Photos", slots: 2, style: .vertical),    // vertical version
    .init(name: "2 Photos", slots: 2, style: .horizontal),  // horizontal version
    .init(name: "3 Photos", slots: 3, style: .vertical),
    .init(name: "3 Photos", slots: 3, style: .horizontal),
    .init(name: "4 Photos", slots: 4, style: .grid(columns: 2)), // 2x2
    .init(name: "4 Photos", slots: 4, style: .vertical),         // 1x4
    .init(name: "6 Photos", slots: 6, style: .grid(columns: 2)), // 2x3 
    .init(name: "6 Photos", slots: 6, style: .grid(columns: 3)), // 2x3
    .init(name: "9 Photos", slots: 9, style: .grid(columns: 3))  // 3x3
]

struct LayoutSelectView: View {
    
    let layouts: [LayoutModel] = predefinedLayouts
    @Binding var selectedLayout: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(layouts.indices, id: \.self) { i in
                    VStack(spacing: 8) {
                        layoutPreview(layout: layouts[i])
                            .frame(width: 60, height: 40)
                            .padding(6)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedLayout == i ? Color.gray : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                        
                        Text(layouts[i].name)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedLayout = i
                        isPresented = false
                    }
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func layoutPreview(layout: LayoutModel) -> some View {
        switch layout.style {
        case .vertical:
            VStack(spacing: 4) {
                ForEach(0..<layout.slots, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(3)
                }
            }
        case .horizontal:
            HStack(spacing: 4) {
                ForEach(0..<layout.slots, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .cornerRadius(3)
                }
            }
        case .grid(let columns):
            let rows = Int(ceil(Double(layout.slots) / Double(columns)))
            VStack(spacing: 4) {
                ForEach(0..<rows, id: \.self) { rowIndex in
                    HStack(spacing: 4) {
                        ForEach(0..<columns, id: \.self) { colIndex in
                            let slotIndex = rowIndex * columns + colIndex
                            Rectangle()
                                .fill(slotIndex < layout.slots ? Color.gray.opacity(0.2) : Color.clear)
                                .cornerRadius(3)
                        }
                    }
                }
            }
        case .custom:
            ZStack {
                Text("Custom")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}
