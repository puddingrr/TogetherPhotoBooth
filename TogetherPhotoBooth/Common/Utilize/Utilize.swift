//
//  ExtentionArrays.swift
//  TogetherPhotoBooth
//
//  Created by MACBOOK PRO on 2/25/26.
//

import Foundation
import UIKit
import SwiftUI

public class Utilize {
    
    static let shared = Utilize()
    private var isAlertPresented = false
   
    func showToast(message: String, duration: Double = 2.0) {
        guard let window = UIApplication.shared.connectedScenes
                       .compactMap({ $0 as? UIWindowScene })
                       .flatMap({ $0.windows })
                       .first(where: { $0.isKeyWindow }) else { return }
        
        let hosting = UIHostingController(rootView: ToastView(message: message))
        hosting.view.backgroundColor = .clear
        hosting.view.frame = window.bounds
        hosting.view.isUserInteractionEnabled = false
        
        window.addSubview(hosting.view)
        
        // Animate toast appearance and disappearance
        hosting.rootView.show = true
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            hosting.rootView.show = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                hosting.view.removeFromSuperview()
            }
        }
    }
        
    func showAlert(title: String = "", message: String, ok: String = "OK", action: (() -> Void)? = nil) {
        guard !isAlertPresented else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let topmostViewController = UIViewController.topMostViewController(),
               !topmostViewController.isBeingPresented, !topmostViewController.isBeingDismissed {
                if !(topmostViewController.presentedViewController is UIAlertController) {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//                    let button = UIAlertAction(title: "OK".uppercased(), style: .cancel) { [weak self] _ in
//                        self?.isAlertPresented = false
//                        action?()
//                    }
//                    alert.addAction(button)
                    topmostViewController.present(alert, animated: true) {
                        self.isAlertPresented = true
                    }
                }
            }
        }
    }
    func showAlertWithButton(title: String = "",
                             message: String,
                             titleFontSize: CGFloat = 16,
                             yesTitle: String = "Yes".uppercased(),
                             noTitle: String = "No".uppercased(),
                             action: ((Int) -> Void)? = nil) {
        Utilize.hideKeyboard()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let attributedTitle = NSAttributedString(
                        string: title,
                        attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: titleFontSize, weight: .bold)]
                    )
                    alert.setValue(attributedTitle, forKey: "attributedTitle")
        let buttonNo = UIAlertAction(title: noTitle, style: .destructive) { _ in
            action?(0)
        }
        alert.addAction(buttonNo)
        
        let buttonYes = UIAlertAction(title: yesTitle, style: .default) { _ in
            action?(1)
        }
        alert.addAction(buttonYes)
        
        if let topmostViewController = UIViewController.topMostViewController(),
            !topmostViewController.isBeingPresented, !topmostViewController.isBeingDismissed {
            topmostViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
