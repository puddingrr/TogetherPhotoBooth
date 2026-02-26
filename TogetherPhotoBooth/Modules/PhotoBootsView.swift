//
//  PhotoBootsView.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/25/26.
//

import SwiftUI

struct PhotoBootsView: View {
    
    @State private var isNavToBoots: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Image(.welcomeScreen)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .cornerRadius(20)

            Text("Ready to capture some memories together?📸💖")
                .foregroundColor(.gray)
            
            Button {
                isNavToBoots = true
            } label: {
                HStack {
                    Text("Capture today, treasure forever!")
                        .foregroundColor(.white)
                    Image("captureBotton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                }
                .padding(10)
                .background(Color.blueLightBG)
                .cornerRadius(10)
            }
        }
        .navigationDestination(isPresented: $isNavToBoots) {
            BoothView()
        }
    }
}
