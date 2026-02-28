//
//  PhotoBootsView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/28/26.
//

import Foundation
import SwiftUI

//
//  PhotoBootsView.swift
//  TogetherPhotoBooth
//

import SwiftUI

struct TextSwiftUI: View {
    var title: String
    var size: CGFloat = 14
    var color: Color = .black
    var weight: Font.Weight = .regular
    var textAlignment: TextAlignment = .leading
    var isUnderline: Bool = false
    var lineLimit: Int? = nil
    var gradientColor: LinearGradient? = nil
    var isAsterisk: Bool = false
    var isScale: Bool = true
    
    var body: some View {
        Text(title)
            .font(.system(size: size, weight: weight))
            .foregroundColor(gradientColor == nil ? color : .clear)
            .underline(isUnderline, color: color)
            .fixedSize(horizontal: false, vertical: true)
            .minimumScaleFactor(isScale ? 0.5 : 1)
            .multilineTextAlignment(textAlignment)
            .lineLimit(lineLimit)
            .overlay {
                if let gradientColor {
                    gradientColor
                        .mask(
                            Text(title)
                                .font(.system(size: size, weight: weight))
                        )
                }
            }
    }
}
