//
//  CreateFeedbackVC+UIGestureRecognizerDelegate.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

extension CreateFeedbackVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Não dispara o gesto se o toque foi em um controle interativo
        return !(touch.view is UIControl)
    }
}
