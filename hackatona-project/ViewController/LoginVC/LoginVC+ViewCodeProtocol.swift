//
//  LoginVC+ViewCodeProtocol.swift
//  hackatona-project
//
//  Created by João Pedro Teixeira de Caralho on 13/05/25.
//

import UIKit

extension LoginVC: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
        view.addSubview(fieldsStackView)
        view.addSubview(emailErrorLabel)
        view.addSubview(passwordErrorLabel)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(createAccountStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 154),
            iconImageView.widthAnchor.constraint(equalToConstant: 154),
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 68),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 33),
            
            fieldsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            fieldsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            fieldsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 83),
            
            emailErrorLabel.leadingAnchor.constraint(equalTo: fieldsStackView.leadingAnchor),
            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: fieldsStackView.leadingAnchor),
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            
            forgotPasswordButton.trailingAnchor.constraint(equalTo: fieldsStackView.trailingAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor),
            
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 71),
            
            createAccountStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
        ])
    }
}
