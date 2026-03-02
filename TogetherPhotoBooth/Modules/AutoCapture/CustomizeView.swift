//
//  CustomizeView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 3/2/26.
//

import SwiftUI

struct CustomizeView: View {
    
    //    @State var images: [UIImage]
    @State private var selectTabIndex: Int = 0
    
    @Environment(\.dismiss) private var dismiss
    
    let itemTab: [CustomUIModel] = [
        .init(icon: "paintpalette.fill", title: "Background", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5)),
        .init(icon: "face.smiling", title: "Sticker", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5)),
        .init(icon: "wand.and.sparkles", title: "Filters", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5))
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "EDDDE8").opacity(0.3).ignoresSafeArea()
            VStack(spacing: 0) {
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
                    TextSwiftUI(title: "Cuztomize", size: 24, color: .black.opacity(0.5), weight: .bold)
                }
                VStack(spacing: 26) {
                    ScrollView(showsIndicators: false) {
                        ZStack {
                            Color.white.cornerRadius(10)
                            VStack {
                                //                            ForEach(images.indices, id: \.self) { i in
                                //                                Image(uiImage: images[i])
                                //                                    .resizable()
                                //                                    .scaledToFill()
                                //                                    .frame(height: 400)
                                //                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                //                            }
                                ForEach(0..<4) { _ in
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.pinkUI, lineWidth: 2)
                                        .frame(height: 300)
                                        .background(Color.pinkUI.cornerRadius(10))
                                }
                            }
                            .padding(12)
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 5)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                    }
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            CustomTabView(index: $selectTabIndex, items: itemTab)
                        }
                        .padding(3)
                        .background(.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                        
                        TabView(selection: $selectTabIndex) {
                            BackgorundUI()
                                .tag(0)
                            StickerUI()
                                .tag(1)
                            FiltersUI()
                                .tag(2)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 170)
                    }
                }
                .padding(EdgeInsets(top: 18, leading: 18, bottom: 0, trailing: 18))

                HStack {
                    Button {
                       
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                            TextSwiftUI(title: "Share", size: 16, color: .white, weight: .bold)
                        }
                        .padding(12)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "99B7DD"))
                        .cornerRadius(12)
                    }
                    Button {
                       
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.down.on.square.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                            TextSwiftUI(title: "Save", size: 16, color: .white, weight: .bold)
                        }
                        .padding(12)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "FC3FAE"))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 12)
                .frame(height: 70)
                .background(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 4, y: 0)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
