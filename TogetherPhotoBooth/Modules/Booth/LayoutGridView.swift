//
//  LayoutGridView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/25/26.
//

import SwiftUI

extension LayoutModel {
    func makeGrid(totalWidth: CGFloat, totalHeight: CGFloat) -> GridLayout {
        GridLayout(layout: self, totalWidth: totalWidth, totalHeight: totalHeight)
    }
}

struct LayoutGridView: View {
    let layout: LayoutModel
    let capturedImages: [UIImage]
    let totalHeight: CGFloat = 600
    
    var body: some View {
        let grid = GridLayout(
            layout: layout,
            totalWidth: UIScreen.main.bounds.width,
            totalHeight: totalHeight
        )
        
        VStack(spacing: grid.spacing) {
            ForEach(0..<grid.rows, id: \.self) { row in
                HStack(spacing: grid.spacing) {
                    ForEach(0..<grid.columns, id: \.self) { column in
                        let index = row * grid.columns + column
                        
                        if index < layout.slots {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                
                                if let image = capturedImages[safe: index] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: grid.slotWidth, height: grid.slotHeight)
                                        .clipped()
                                }
                            }
                            .frame(width: grid.slotWidth, height: grid.slotHeight)
                            .cornerRadius(8)
                        } else {
                            Spacer()
                                .frame(width: grid.slotWidth, height: grid.slotHeight)
                        }
                    }
                }
            }
        }
        .frame(height: totalHeight)
        .padding(.horizontal, grid.horizontalPadding)
    }
}

struct GridLayout {
    let layout: LayoutModel
    let totalWidth: CGFloat
    let totalHeight: CGFloat
    
    let horizontalPadding: CGFloat = 8
    let spacing: CGFloat = 4
    
    var columns: Int {
        switch layout.style {
        case .vertical:
            return 1
            
        case .horizontal:
            return layout.slots
            
        case .grid(let columns):
            return columns
            
        case .custom:
            return 1
        }
    }
    
    var rows: Int {
        switch layout.style {
        case .horizontal:
            return 1
            
        case .vertical:
            return layout.slots
            
        case .grid:
            return Int(ceil(Double(layout.slots) / Double(columns)))
            
        case .custom:
            return 1
        }
    }
    
    var slotWidth: CGFloat {
        let totalSpacing = CGFloat(columns - 1) * spacing
        return (totalWidth - horizontalPadding * 2 - totalSpacing) / CGFloat(columns)
    }
    
    var slotHeight: CGFloat {
        let totalSpacing = CGFloat(rows - 1) * spacing
        return (totalHeight - totalSpacing) / CGFloat(rows)
    }
    
    func position(for index: Int) -> (row: Int, column: Int) {
        let row = index / columns
        let column = index % columns
        return (row, column)
    }
}
