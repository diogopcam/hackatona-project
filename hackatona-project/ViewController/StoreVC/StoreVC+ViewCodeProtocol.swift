//
//  StoreVC+ViewCodeProtocol.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

extension StoreVC: ViewCodeProtocol {
    func addSubViews() {
        title = "Store"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .backgroundPrimary
        
        view.addSubview(headerView)
        headerView.addSubview(pointsLabel)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pointsLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            pointsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
