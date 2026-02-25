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
    let horizontalPadding: CGFloat = 8
    let spacing: CGFloat = 4
    
    var columns: Int {
        if layout.slots <= 3 { return 1 }
        else if layout.slots == 4 { return 2 }
        else { return 3 }
    }
    
    var rows: Int {
        Int(ceil(Double(layout.slots) / Double(columns)))
    }
    
    var slotHeight: CGFloat {
        (totalHeight - CGFloat(rows - 1) * spacing) / CGFloat(rows)
    }
    
    var slotWidth: CGFloat {
        let totalWidth = UIScreen.main.bounds.width - horizontalPadding * 2
        return (totalWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<columns, id: \.self) { column in
                        let index = row * columns + column
                        
                        if index < layout.slots {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.1))
                                
                                if let image = capturedImages[safe: index] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: slotWidth, height: slotHeight)
                                        .clipped()
                                }
                            }
                            .frame(width: slotWidth, height: slotHeight)
                            .clipped()
                            .cornerRadius(8)
                        } else {
                            Spacer()
                                .frame(width: slotWidth, height: slotHeight)
                        }
                    }
                }
            }
        }
        .frame(height: totalHeight)
        .padding(.horizontal, horizontalPadding)
    }
}
