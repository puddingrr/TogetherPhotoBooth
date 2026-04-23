//
//  ProfileView.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 4/23/26.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var showDrafts = false
    @State private var loadedDraft: DraftData? = nil
    @State private var draftImages: [UIImage] = []
    
    var body: some View {
        VStack {
            Button {
                loadDraft()
                showDrafts = true
            } label: {
                TextSwiftUI(title: "View Drafts", size: 14, color: .gray)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "FFB399"), lineWidth: 2)
                    )
            }
        }
        .padding(16)
        .navigationTitle("Profile")
        .onAppear {
            loadDraft()
        }
        .sheet(isPresented: $showDrafts) {
                DraftsView(draft: $loadedDraft, images: $draftImages)
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



