//
//  View.swift
//  TogetherPhotoBooth
//
//  Created by Dalynn on 2/26/26.
//
import Foundation
import UIKit

extension UIViewController {
    class func topMostViewController() -> UIViewController? {
        
        // In iOS 13.0 and later,
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let windows = windowScene.windows
            // Access windows specific to the scene
            if let keyWindow = windows.first(where: { $0.isKeyWindow }) {
                var topController = keyWindow.rootViewController
                while let presentedViewController = topController?.presentedViewController {
                    topController = presentedViewController
                }
                return topController
            }
        }
        return nil
    }
}
