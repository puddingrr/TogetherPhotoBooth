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
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                ForEach(frames) { frame in
                    Image(frame.name)
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
                                .stroke(
                                    selectedFrame.name == frame.name ? Color.gray : Color.clear,
                                    lineWidth: 3
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
