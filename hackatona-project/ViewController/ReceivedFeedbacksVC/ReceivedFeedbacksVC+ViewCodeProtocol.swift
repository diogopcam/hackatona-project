//
//  ReceivedFeedbacksVC+ViewCodeProtocol.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//

import UIKit

extension ReceivedFeedbacksVC: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
