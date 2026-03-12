//
//  PhotoBootsView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/25/26.
//

import SwiftUI

struct PhotoBootsView: View {
    
    @State private var isNavToBoots: Bool = false
    @State private var isNavTo4Shot: Bool = false
    @State private var showPicker = false
    @State private var isNavtoUploadPhotoReview = false
    @State private var selectedImages: [UIImage] = []
    @State private var isLoading = false
    @State private var fromPhotoView: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                TextSwiftUI(title: "📸 Together x Booth", size: 36, weight: .bold)
                TextSwiftUI(title: "Create cute collage!!", size: 14, color: .gray)
                
                Spacer(minLength: 0)
                
                VStack(spacing: 24) {
                    Button {
                        isNavTo4Shot = true
                    } label: {
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.pinkLight.opacity(0.4))
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 34, height: 34)
                                    .foregroundColor(.pink.opacity(0.4))
                            }
                            VStack(spacing: 5) {
                                TextSwiftUI(title: "Take Photos", size: 22, weight: .bold)
                                TextSwiftUI(title: "Auto-capture 4 shots", size: 14, color: .gray)
                            }
                        }
                        .padding(32)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.pinkLight, lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                        
                    }
                    
                    Button {
                        showPicker = true
                    } label: {
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.bluesky.opacity(0.4))
                                Image(systemName: "photo.on.rectangle.angled")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 34, height: 34)
                                    .foregroundColor(.blue.opacity(0.4))
                            }
                            
                            VStack(spacing: 5) {
                                TextSwiftUI(title: "Upload Photos", size: 22, weight: .bold)
                                TextSwiftUI(title: "Choose up to 4 photos", size: 14, color: .gray)
                            }
                        }
                        .padding(32)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.bluesky, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                    }
                }
                
                Spacer(minLength: 0)
                TextSwiftUI(title: "Korean-style photo booth", size: 14, color: .gray)
            }.padding(16)
            
            if isLoading {
                LoadingUI2()
            }
        }
        .navigationDestination(isPresented: $isNavTo4Shot) {
            AutoCapture4ShotView()
        }
        .sheet(isPresented: $showPicker, onDismiss: {
            if !selectedImages.isEmpty {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                    isNavtoUploadPhotoReview = true
                }
            }
        }) {
            PhotoPicker(selectedImages: $selectedImages, maxSelection: 4)
        }
        .navigationDestination(isPresented: $isNavtoUploadPhotoReview) {
            UploadPhotoView(
                images: selectedImages.map { Optional($0) } + Array(repeating: nil, count: 4 - selectedImages.count),
                isPresented: $isNavtoUploadPhotoReview, formCapture: false
            )
        }
    }
}
