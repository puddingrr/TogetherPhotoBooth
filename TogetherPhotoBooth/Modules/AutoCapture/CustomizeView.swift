//
//  CustomizeView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 3/2/26.
//

import SwiftUI

struct CustomizeView: View {
    
    @State var images: [UIImage]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(hex: "EEE8FE").ignoresSafeArea()
            VStack(spacing: 22) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 22, weight: .bold))
                            .scaledToFit()
                            .foregroundColor(.black)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.4))
                            )
                    }
                    Spacer()
                }
                .overlay {
                    TextSwiftUI(title: "Cuztomize", size: 28, color: .black.opacity(0.5), weight: .bold)
                }
                
                ScrollView {
                    ZStack {
                        Color.white.cornerRadius(10)
                        VStack {
                            ForEach(images.indices, id: \.self) { i in
                                Image(uiImage: images[i])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 400)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, 16)
                
                Button {
                   
                } label: {
                    HStack(spacing: 4) {
                       
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                }
                
                Spacer()
                
            }
            .padding(24)
        }
        .navigationBarBackButtonHidden(true)
    }
}
