//
//  CustomizeView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 3/2/26.
//

import SwiftUI

struct CustomizeView: View {
    
    @State var images: [UIImage]
    @State private var selectTabIndex: Int = 0
    
    @Environment(\.dismiss) private var dismiss
    
    let itemTab: [CustomUIModel] = [
        .init(icon: "paintpalette.fill", title: "Background", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5)),
        .init(icon: "face.smiling", title: "Sticker", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5)),
        .init(icon: "wand.and.sparkles", title: "Filters", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5))
    ]
    
    @State private var selectedBackground: Color = .white
    @State private var selectedStickers: [StickerItem] = []
    @State private var selectedFilter: Color = .white
    
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
                            selectedBackground
                            VStack {
                                ForEach(images.indices, id: \.self) { i in
                                    ZStack {
                                        Image(uiImage: images[i])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 400)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        //filter color apply for image
                                        selectedFilter.opacity(0.1)
                                        
                                        ForEach($selectedStickers.filter { $0.parentImageIndex.wrappedValue == i }) { $sticker in
                                            StickerView(sticker: $sticker)
                                        }
                                    }
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
                            BackgroundUI(selectedBackground: $selectedBackground)
                                .tag(0)
                            StickerUI(selectedStickers: $selectedStickers)
                                .tag(1)
                            FiltersUI(selectedFilter: $selectedFilter)
                                .tag(2)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 170)
                    }
                    .padding(.top, -10)
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

// MARK: - Individual StickerView
struct StickerView: View {
    @Binding var sticker: StickerItem
    
    @State private var dragOffset: CGSize = .zero
    @State private var currentScale: CGFloat = 1.0
    @State private var currentRotation: Angle = .zero
    @State private var isDraggingCorner = false
    
    var body: some View {
        ZStack {
            Text(sticker.emoji)
                .font(.system(size: 40))
                .scaleEffect(sticker.scale * currentScale)
                .rotationEffect(sticker.rotation + currentRotation)
                .position(x: sticker.position.x + dragOffset.width,
                          y: sticker.position.y + dragOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            sticker.position.x += value.translation.width
                            sticker.position.y += value.translation.height
                            dragOffset = .zero
                        }
                )
            
            // Corner handle for scaling
            Circle()
                .fill(Color.blue.opacity(0.7))
                .frame(width: 20, height: 20)
                .position(
                    x: sticker.position.x + dragOffset.width + 40 * sticker.scale * currentScale,
                    y: sticker.position.y + dragOffset.height + 40 * sticker.scale * currentScale
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDraggingCorner = true
                            let distance = sqrt(value.translation.width * value.translation.width +
                                                value.translation.height * value.translation.height)
                            currentScale = 1.0 + distance / 100
                        }
                        .onEnded { _ in
                            sticker.scale *= currentScale
                            currentScale = 1.0
                            isDraggingCorner = false
                        }
                )
        }
    }
}

// Convenience operator to add CGSize + CGPoint
fileprivate func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
    CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
}
