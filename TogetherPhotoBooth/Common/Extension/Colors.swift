//
//  Colors.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/26/26.
//
import SwiftUI

extension Color {
    
    static let UpdatePhotosBgGredient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "E5F0FE"), Color(hex: "FBE8F9")]),
        startPoint: .top,
        endPoint: .bottom
    )
    static let pinkBgGredient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "F9C5E5"), Color(hex: "EBD3E7")]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff
        )
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
