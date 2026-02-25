//
//  LayoutGridView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/25/26.
//

import SwiftUI

struct LayoutGridView: View {
    let layout: FrameModel
    let capturedImages: [UIImage]
    let totalHeight: CGFloat = 600
    
    var body: some View {
        let grid = GridLayout(
            slotCount: layout.slots,
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
    let slotCount: Int
    let totalWidth: CGFloat
    let totalHeight: CGFloat
    let horizontalPadding: CGFloat = 8
    let spacing: CGFloat = 4
    
    var columns: Int {
        if slotCount <= 3 { return 1 }
        else if slotCount == 4 { return 2 }
        else { return 3 }
    }
    
    var rows: Int {
        Int(ceil(Double(slotCount) / Double(columns)))
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
