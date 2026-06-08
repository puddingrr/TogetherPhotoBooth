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
    @State private var selectedShotCount: Int = 4
    @State private var showShotSelection = false
    @State private var draftPreviewImage: UIImage? = nil
    @State private var isNavProfileView: Bool = false
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                TextSwiftUI(title: "📸 Together x Booth", size: 36, color: .pinkUI, weight: .bold)
                TextSwiftUI(title: "Create cute collage!!", size: 14, color: .gray)
                
                Spacer(minLength: 0)
                
                VStack(spacing: 24) {
                    Button {
                        showShotSelection = true
                    } label: {
                        CameraButtonView(title: "Take Photos", subtitle: "Auto-capture 4 shots", icon: "camera.fill", bgColor: .pinkLight, fgColor: .pink)
                    }
                    
                    Button {
                        showPicker = true
                    } label: {
                        CameraButtonView(title: "Upload Photos", subtitle: "Choose up to 4 photos", icon: "photo.on.rectangle.angled", bgColor: .bluesky, fgColor: .blue)
                    }
                }
                
                Spacer(minLength: 0)
                Button {
                    isNavProfileView = true
                } label: {
                    HStack {
                        TextSwiftUI(title: "Korean-style booth Profile", size: 14, color: .gray)
                        Image(systemName: "person.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }.padding(16)
            
            if isLoading {
                LoadingUI2()
            }
        }
        .confirmationDialog("Choose number of shots 💕", isPresented: $showShotSelection, titleVisibility: .visible) {
            Button("2 Shots") { selectedShotCount = 2; isNavTo4Shot = true }
            Button("4 Shots") { selectedShotCount = 4; isNavTo4Shot = true }
            Button("Cancel", role: .cancel) { }
        }
        .navigationDestination(isPresented: $isNavTo4Shot) {
            AutoCapture4ShotView(totalShots: selectedShotCount)
        }
        .navigationDestination(isPresented: $isNavProfileView) {
            ProfileView()
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
extension PhotoBootsView {
    private func handlePickerDismiss() {
           if !selectedImages.isEmpty {
               isLoading = true
               DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                   isLoading = false
                   isNavtoUploadPhotoReview = true
               }
           }
       }
}



// MARK: - Reusable Camera Button
struct CameraButtonView: View {
    let title: String
    let subtitle: String
    let icon: String
    let bgColor: Color
    let fgColor: Color
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .frame(width: 80, height: 80)
                    .foregroundColor(bgColor.opacity(0.4))
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 34, height: 34)
                    .foregroundColor(fgColor.opacity(0.4))
            }
            VStack(spacing: 5) {
                TextSwiftUI(title: title, size: 22, weight: .bold)
                TextSwiftUI(title: subtitle, size: 14, color: .gray)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(bgColor, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
    }
}
