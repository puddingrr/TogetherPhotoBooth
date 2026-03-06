//
//  CustomToast.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 3/6/26.
//
import SwiftUI

struct ToastView: View {
    let message: String
    @State var show: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            if show {
                Text(message)
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: show)
    }
}
