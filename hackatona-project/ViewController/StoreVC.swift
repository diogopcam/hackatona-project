//
//
//
//  StoreViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

class StoreViewController: UIViewController {
    
    private let feedbackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Abrir Feedback", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.systemOrange, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemOrange
        
        let label = UILabel()
        label.text = "Loja"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
//        // Configuração do botão de feedback
//        view.addSubview(feedbackButton)
//        feedbackButton.addTarget(self, action: #selector(navigateToFeedback), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            feedbackButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            feedbackButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackButton.widthAnchor.constraint(equalToConstant: 200),
            feedbackButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
//    @objc func navigateToFeedback() {
//        let feedbackViewController = CreateFeedbackVC(employee: <#Employee#>)
//        navigationController?.pushViewController(feedbackViewController, animated: true)
//    }
}

