//
//  FrameSelectView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//
import SwiftUI

struct FrameSelectView: View {
    
    let frames: [FrameModel]
    @Binding var selectedFrame: Int?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                ForEach(frames.indices, id: \.self) { i in
                    Image(frames[i].name)
                        .resizable()
                        .padding(4)
                        .frame(width: 60, height: 100)
                        .cornerRadius(10)
                        .background(Color.white.cornerRadius(5))
                        .onTapGesture {
                            if selectedFrame == i {
                                selectedFrame = nil 
                            } else {
                                selectedFrame = i
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(
                                    selectedFrame == i ? Color.gray : Color.clear,
                                    lineWidth: 2
                                )
                        )
                }
            }
            .padding()
        }
    }
}

struct FrameModel {
    let name: String
    let slots: Int
}

let frameModels: [FrameModel] = [
    .init(name: "frame1", slots: 1),
    .init(name: "frame2", slots: 2),
    .init(name: "frame3", slots: 3),
    .init(name: "frame4", slots: 4),
    .init(name: "frame6", slots: 6)
]
