//
//  PhotoBootsViewModel.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/25/26.
//

import SwiftUI
import Combine


class PhotoBootsViewModel: ObservableObject {
    
    // Booth
    
    @Published var capturedImages: [UIImage] = []
    @Published var currentSlotIndex = 0

    @Published var selectedLayoutIndex: Int = 0
    @Published var isSelectLayout = false
    
    func resetSession() {
        capturedImages = []
        currentSlotIndex = 0
    }
    
    // Photo
    
    @Published var stickers: [UIImage] = []
    @Published var showSavedAlert = false
    
    @Published var showTextEditor = false
    @Published var newText: String = ""
    @Published var showStickerSheet = false
    @Published var showPhotoPicker = false
    @Published var drawingEnabled = false
    
    @Published var selectedFrameIndex: Int = 0
    @Published var isSelectFrame = false
}
