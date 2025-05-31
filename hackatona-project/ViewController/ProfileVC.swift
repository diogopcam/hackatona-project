//
//  ProfileViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//
import UIKit

class ProfileViewController: UIViewController {

    private lazy var headerView = ProfileHeader()
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension ProfileViewController: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(headerView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])

        view.backgroundColor = .black
        headerView.translatesAutoresizingMaskIntoConstraints = false
    }
}
