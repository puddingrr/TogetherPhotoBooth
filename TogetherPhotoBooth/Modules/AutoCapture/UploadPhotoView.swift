//
//  UploadPhotoView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 3/1/26.
//
import SwiftUI

struct UploadPhotoView: View {
    
    @State private var isNavtoCustomize = false
    @State var images: [UIImage?]
    var onRetake: ([UIImage]) -> Void
    
    init(images: [UIImage], onRetake: @escaping ([UIImage]) -> Void) {

        var arr: [UIImage?] = Array(repeating: nil, count: 4)

        for (i, img) in images.enumerated() {
            if i < 4 {
                arr[i] = img
            }
        }

        _images = State(initialValue: arr)
        self.onRetake = onRetake
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

                            VStack {
                                HStack {
                                    Spacer()
                                    if images.indices.contains(i), images[i] != nil {
                                        Button {
                                            images[i] = nil
                                            print("Remove index \(i)")
                                            
//                                            let newImages = images.compactMap { $0 }
//                                            onRetake(newImages)
//                                            
//                                            dismiss()
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(8)
                                                .background(
                                                    Circle().fill(Color(hex: "C56E92"))
                                                )
                                                .overlay(
                                                    Circle().stroke(Color.white, lineWidth: 3)
                                                )
                                        }
                                    }
                                }
                                Spacer()
                                HStack {
                                    Text("\(i+1)")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(8)
                                        .background(
                                            Circle().fill(Color(hex: "C56E92"))
                                        )

                                    Spacer()
                                }
                            }
                            .padding(10)
                        }
                    }
                }
                .padding(.top, 30)
                
                let selected = images.compactMap { $0 }.count
                Button {
                    let newImages = images.compactMap { $0 }
                    onRetake(newImages)
                    
                    if newImages.count == 4 {
                        isNavtoCustomize = true
                    } else {
                        dismiss()
                    }
                } label: {
                    VStack(spacing: 4) {
                        let selected = images.compactMap { $0 }.count
                        TextSwiftUI(title: "📸 Select \(4 - selected) more photos",
                                    size: 22, weight: .bold)
                        TextSwiftUI(title: "\(selected)/4 photos selected", size: 14, color: .gray)
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
                }.disabled(selected != 4)
                
                Spacer()
                
            }
            .padding(24)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $isNavtoCustomize) {
            CustomizeView(images: images.compactMap { $0 })
        }
    }
}
