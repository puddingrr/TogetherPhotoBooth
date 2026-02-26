//
//  FrameSelectView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//
import SwiftUI

struct FrameSelectView: View {
    
    let frames: [FrameModel] = frameModels
    @Binding var selectedFrame: FrameModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                ForEach(frames) { frame in
                    Image(frame.name)
                        .resizable()
                        .padding(4)
                        .frame(width: 60, height: 100)
                        .cornerRadius(10)
                        .background(Color.white.cornerRadius(5))
                        .onTapGesture {
                            selectedFrame = frame
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(
                                    selectedFrame.name == frame.name ? Color.gray : Color.clear,
                                    lineWidth: 2
                                )
                        )
                }
            }
            .padding()
        }
    }
}

struct FrameModel: Identifiable {
    let id: Int
    let name: String
    let slots: Int
}

let frameModels: [FrameModel] = [
    FrameModel(id: 1, name: "frame1", slots: 1),
    FrameModel(id: 2, name: "frame2", slots: 2),
    FrameModel(id: 3, name: "frame3", slots: 3),
    FrameModel(id: 4, name: "frame4", slots: 4),
    FrameModel(id: 5, name: "frame6", slots: 6)
]
