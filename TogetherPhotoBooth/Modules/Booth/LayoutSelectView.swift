//
//  LayoutView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/25/26.
//
import SwiftUI

struct LayoutSelectView: View {
    
    let layouts: [FrameModel] = frameModels
    @Binding var selectedLayout: FrameModel
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                
                ForEach(layouts) { layout in
                    VStack(spacing: 8) {
                        
                        layoutPreview(layout: layout)
                            .frame(width: 60, height: 40)
                            .padding(6)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedLayout.id == layout.id ? Color.gray : Color.clear,
                                        lineWidth: 3
                                    )
                            )
                        
                        Text("\(layout.slots) Photos")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        selectedLayout = layout
                        isPresented = false
                    }
                }
            }
            .padding()
        }
    }
    
    func layoutPreview(layout: FrameModel) -> some View {
        let columns: Int
        if layout.slots <= 3 {
            columns = 1           // vertical stack
        } else if layout.slots == 4 {
            columns = 2           // 2x2
        } else {
            columns = 3           // 5–6 → 3 columns
        }
        
        let rows = Int(ceil(Double(layout.slots) / Double(columns)))
        
        return VStack(spacing: 4) {
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
    }
}
