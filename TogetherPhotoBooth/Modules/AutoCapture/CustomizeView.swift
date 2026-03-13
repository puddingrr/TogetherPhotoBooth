//
//  CustomizeView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 3/2/26.
//

import SwiftUI

struct ShareImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct CustomizeView: View {
    
    @State var images: [UIImage]
    @State private var selectTabIndex: Int = 0
    @State private var currentVisibleImageIndex: Int = 0
    
    @Environment(\.dismiss) private var dismiss
    
    let itemTab: [CustomUIModel] = [
        .init(icon: "paintpalette.fill", title: "Background", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5)),
        .init(icon: "face.smiling", title: "Sticker", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5)),
        .init(icon: "wand.and.sparkles", title: "Filters", color: Color(hex: "9C728C"), background: .pinkUI.opacity(0.5))
    ]
    
    @State private var selectedBackground: Color = .white
    @State private var selectedStickers: [StickerItem] = []
    @State private var selectedFilter: Color = .white
    @State private var shareImage: ShareImage?
    @State private var showSavedPopup = false
    
    let imageHeight: CGFloat = 400 // consistent height for preview and export
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "EDDDE8").opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
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
                    // Preview ScrollView
                    ScrollView(showsIndicators: false) {
                        ZStack {
                            selectedBackground
                            VStack {
                                ForEach(images.indices, id: \.self) { i in
                                    GeometryReader { geo in
                                        ZStack {
                                            Image(uiImage: images[i])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: imageHeight)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .clipped()
                                            
                                            selectedFilter.opacity(0.1)
                                            
                                            // Stickers
                                            ForEach($selectedStickers.filter { $0.parentImageIndex.wrappedValue == i }) { $sticker in
                                                StickerView(sticker: $sticker)
                                            }
                                        }
                                        .onChange(of: geo.frame(in: .global).midY) { value in
                                            let screenCenter = UIScreen.main.bounds.midY
                                            if abs(value - screenCenter) < 200 {
                                                currentVisibleImageIndex = i
                                            }
                                        }
                                    }
                                    .frame(height: imageHeight)
                                }
                            }
                            .padding(12)
                        }
                        .padding(.horizontal, 12)
                        .padding(.bottom, 5)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                    }
                    
                    // Tabs
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
                            StickerUI(
                                selectedStickers: $selectedStickers,
                                currentVisibleImageIndex: currentVisibleImageIndex
                            )
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
                
                // Bottom Buttons
                HStack {
                    Button {
                        shareImageAction()
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
                        saveImage()
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
            
            // Saved Popup
            if showSavedPopup {
                VStack {
                    Spacer()
                    Text("Saved Successfully! 💖")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.bottom, 100)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(item: $shareImage) { item in
            ShareSheet(activityItems: [item.image]) {
                DispatchQueue.main.async {
                    showSavedPopup = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showSavedPopup = false
                        Utilize.popToRootView(animated: true)
                    }
                }
            }
        }
    }
}

extension CustomizeView {
    // MARK: - Save Image
    func saveImage() {
        if let uiImage = renderImage() {
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            showSavedPopup = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showSavedPopup = false
                Utilize.popToRootView(animated: true)
            }
        }
    }
    
    // MARK: - Share Image
    func shareImageAction() {
        Task { @MainActor in
            if let image = renderImage() {
                shareImage = ShareImage(image: image)
            } else {
                print("Render failed")
            }
        }
    }
    
    // MARK: - Render Export Image
    @MainActor
    func renderImage() -> UIImage? {
        // Width = screen width, height = number of images * imageHeight + padding
        let exportWidth: CGFloat = UIScreen.main.bounds.width
        let exportHeight: CGFloat = CGFloat(images.count) * (imageHeight + 12) + 12

        let view = exportView
            .frame(width: exportWidth, height: exportHeight)

        let renderer = ImageRenderer(content: view)
        renderer.scale = UIScreen.main.scale

        if let image = renderer.uiImage {
            return removeAlpha(image)
        }
        return nil
    }
    
    // MARK: - Export View
    var exportView: some View {
        ZStack {
            selectedBackground
            VStack(spacing: 12) {
                ForEach(images.indices, id: \.self) { i in
                    ZStack {
                        // Full screen width minus the same horizontal padding
                        let imageWidth = UIScreen.main.bounds.width - 24
                        Image(uiImage: images[i])
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageWidth, height: imageHeight)
                            .clipped()
                            .cornerRadius(10)
                        
                        selectedFilter.opacity(0.1)
                        
                        // Stickers for this image
                        ForEach(selectedStickers.filter { $0.parentImageIndex == i }) { sticker in
                            Text(sticker.emoji)
                                .font(.system(size: 40))
                                .scaleEffect(sticker.scale)
                                .rotationEffect(sticker.rotation)
                                .position(
                                    x: sticker.position.x - 8,       // match horizontal padding
                                    y: sticker.position.y - 9   // vertical padding
                                )
                        }
                    }
                }
            }
            .padding(12)
        }
        .frame(width: UIScreen.main.bounds.width)
    }
    
    func removeAlpha(_ image: UIImage) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.opaque = true
        
        let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
        
        return renderer.image { _ in
            UIColor.white.setFill()
            UIBezierPath(rect: CGRect(origin: .zero, size: image.size)).fill()
            image.draw(at: .zero)
        }
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
            // Sticker Emoji
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
            Image(systemName: "crop.rotate")
                .foregroundColor(Color.pinkUI)
                .frame(width: 20, height: 20)
                .position(
                    x: sticker.position.x + dragOffset.width + 30 * sticker.scale * currentScale,
                    y: sticker.position.y + dragOffset.height + 30 * sticker.scale * currentScale
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

// Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    var onComplete: (() -> Void)?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        controller.completionWithItemsHandler = { _, _, _, _ in
            onComplete?()
        }
        
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
