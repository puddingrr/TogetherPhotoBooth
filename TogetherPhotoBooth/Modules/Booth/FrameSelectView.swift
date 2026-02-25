//
//  FrameSelectView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/24/26.
//
import SwiftUI

struct FrameSelectView: View {
    
    let frames = ["frame1", "frame2", "frame3", "frame4", "frame5", "frame6"]
    @Binding var selectedFrame: String
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(frames, id: \.self) { frame in
                    Image(frame)
                        .resizable()
                        .frame(width: 60, height: 100)
                        .cornerRadius(10)
                        .background(Color.white.cornerRadius(10))
                        .onTapGesture {
                            selectedFrame = frame
                            isPresented = false 
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedFrame == frame ? Color.gray : Color.clear, lineWidth: 3)
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
    FrameModel(name: "frame1", slots: 1),
    FrameModel(name: "frame2", slots: 2),
    FrameModel(name: "frame3", slots: 3),
    FrameModel(name: "frame4", slots: 4),
    FrameModel(name: "frame6", slots: 6)
]
