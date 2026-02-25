//
//  ExtentionArrays.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/25/26.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
