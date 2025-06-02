//
//  ProfileVC+Actions.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

// MARK: - Actions

extension ProfileVC {
    @objc func seeAllReceived() {
        let vc = ReceivedFeedbacksVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func seeAllSended() {
        let vc = SendedFeedbacksVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
