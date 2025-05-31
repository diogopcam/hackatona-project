//
//  Extensions.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation
import UIKit

typealias Size = NSCollectionLayoutSize
typealias Item = NSCollectionLayoutItem
typealias Group = NSCollectionLayoutGroup
typealias Section = NSCollectionLayoutSection
typealias Layout = UICollectionViewCompositionalLayout
typealias Edges = NSDirectionalEdgeInsets
typealias Config = UICollectionViewCompositionalLayoutConfiguration

extension String {
    func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension UIViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Keyboard Handling Extension
extension UIViewController {
    
    func registerForKeyboardNotifications(referenceView: UIView? = nil, offset: CGFloat = 50) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self,
                  let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            if let referenceView = referenceView {
                let referenceFrame = referenceView.convert(referenceView.bounds, to: self.view)
                let bottomSpace = self.view.frame.height - (referenceFrame.origin.y + referenceFrame.height)
                if bottomSpace < keyboardHeight {
                    self.view.frame.origin.y = -(keyboardHeight - bottomSpace + offset)
                }
            } else {
                self.view.frame.origin.y = -(keyboardHeight / 2.5 + offset)
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.view.frame.origin.y = 0
        }
    }
    
    func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

