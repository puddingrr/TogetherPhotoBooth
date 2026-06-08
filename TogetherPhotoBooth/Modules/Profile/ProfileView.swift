//
//  ProfileView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 4/23/26.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var isNavEditProfile: Bool = false
    @State private var showDrafts = false
    @State private var loadedDraft: DraftData? = nil
    @State private var draftImages: [UIImage] = []
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let images: [ImageResource] = [.profile, .profile, .profile, .profile, .profile, .profile, .profile,
                                   .profile, .profile, .profile, .profile, .profile, .profile, .profile, .profile]
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                Image(.cover)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                
                Image(.profile)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.pinkUI, lineWidth: 3)
                    )
                    .padding(.leading, 16)
                    .offset(y: 35)
            }
            .padding(.bottom, 35)
            
            VStack(alignment: .leading, spacing: 16) {
                TextSwiftUI(title: "Sensitive about everything", size: 14)
                HStack(spacing: 8) {
                    Button {
                        isNavEditProfile = true
                    } label: {
                        TextSwiftUI(title: "Edit Profile", size: 14, color: .pinkUI)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.pinkUI, lineWidth: 2)
                            )
                    }

                    Button {
                        loadDraft()
                        showDrafts = true
                    } label: {
                        TextSwiftUI(title: "View Drafts", size: 14, color: .pinkUI)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.pinkUI, lineWidth: 2)
                            )
                    }

                    Button {
                    } label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.pinkUI, lineWidth: 2)
                            )
                    }
                }
                TextSwiftUI(title: "Saved Photo ideas", size: 18, color: .gray, weight: .bold)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 6) {
                        ForEach(images.indices, id: \.self) { i in
                            Image(images[i])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(10)
                                .background(.pinkUI)
                        }
                    }
                }
            }
            .padding(16)
            Spacer()
        }
        .ignoresSafeArea()
        .onAppear {
            loadDraft()
        }
        .sheet(isPresented: $showDrafts) {
                DraftsView(draft: $loadedDraft, images: $draftImages)
        }
        .navigationDestination(isPresented: $isNavEditProfile) {
            EditProfileView()
        }
    }
}
extension ProfileView {
    private func loadDraft() {
        guard let data = UserDefaults.standard.data(forKey: "draft_data"),
              let draft = try? JSONDecoder().decode(DraftData.self, from: data) else { return }
        
        draftImages = draft.images.compactMap { UIImage(data: $0) }
        loadedDraft = draft
    }
}

struct DraftsView: View {
    @Binding var draft: DraftData?
    @Binding var images: [UIImage]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if images.isEmpty {
                    Text("No drafts available 💔")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(Array(stride(from: 0, to: images.count, by: 2)), id: \.self) { index in
                                HStack(spacing: 8) {
                                    Image(uiImage: images[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 160)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                        .cornerRadius(10)
                                    
                                    if index + 1 < images.count {
                                        Image(uiImage: images[index + 1])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 160)
                                            .frame(maxWidth: .infinity)
                                            .clipped()
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Saved Drafts 💌")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}



