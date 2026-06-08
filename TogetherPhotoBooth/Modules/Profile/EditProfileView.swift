//
//  EditProfileView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 4/23/26.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @State private var showPicker = false
    @State var selectedItem: PhotosPickerItem?
    @State var selectedProfileImage: UIImage?
    @State var selectedCoverImage: UIImage?
    @State var isPickingCover = false
    @State var isPickingProfile: Bool = false

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Button {
                    showPicker = true
                    isPickingCover = true
                } label: {
                    Image(.cover)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.pinkUI, lineWidth: 3)
                        )
                }
                
                ZStack(alignment: .bottomTrailing) {
                    Image(.profile)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.pinkUI, lineWidth: 3)
                        )
                    Button {
                        showPicker = true
                        isPickingProfile = true
                    } label: {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 34, height: 34)
                            .overlay {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(.pinkUI)
                            }
                    }
                }
                .offset(y: 35)
            }
            .padding(.bottom, 35)

            Spacer()
        }
        .padding(12)
        .navigationTitle("Edit Profile")
        .sheet(isPresented: $showPicker) {
       
        }
    }
}
