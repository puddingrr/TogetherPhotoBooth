//
//  UploadPhotoView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 3/1/26.
//
import SwiftUI

struct UploadPhotoView: View {
    
    @State var images: [UIImage?]
    
    init(images: [UIImage]) {
        _images = State(initialValue: images.map { Optional($0) })
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.UpdatePhotosBgGredient.ignoresSafeArea()
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
                    TextSwiftUI(title: "Upload Photo", size: 28, color: .black.opacity(0.5), weight: .bold)
                }
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<4, id: \.self) { i in
                        ZStack {
                            if let img = images[i] {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.15))
                                    .frame(height: 200)
                            }
                            Color.white.opacity(0.1)
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        images.remove(at: i)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.system(size: 18, weight: .bold))
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(
                                                Circle()
                                                    .fill(Color(hex: "C56E92"))
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 3)
                                            )
                                    }
                                }
                                Spacer()
                                HStack {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Circle()
                                            .fill(Color(hex: "C56E92"))
                                            .frame(width: 18, height: 18)
                                            .overlay {
                                                TextSwiftUI(title: "\(i)", color: .white, weight: .bold)
                                            }
                                    }
                                    Spacer()
                                }
                            }
                            .padding(16)
                        }
                    }
                }
                .padding(.top, 30)
                
                VStack(spacing: 4) {
                    TextSwiftUI(title: "📸 Select \(4 - images.count) more photos",
                                size: 22, weight: .bold)
                    TextSwiftUI(title: "\(images.count)/4 photos selected", size: 14, color: .gray)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(Color(hex: "F9F7FF"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                
                Spacer()
                
            }
            .padding(24)
        }
        .navigationBarBackButtonHidden(true)
    }
}
