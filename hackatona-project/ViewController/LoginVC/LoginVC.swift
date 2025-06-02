//
//  LoginViewController.swift
//  Incentiv8
//
//  Created by João Pedro Teixeira de Caralho on 13/05/25.
//
import UIKit

class LoginVC: UIViewController {
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profileImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = .systemFont(ofSize: 48, weight: .bold)
        
        return label
    }()

    lazy var emailTextField = NamedTextField(title: "Email", placeholder: "abc@abc.com")
    
    lazy var passwordTextField = NamedTextField(title: "Password", placeholder: "********", isPassword: true)
    
    lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    lazy var forgotPasswordButton = Components.getButton(content: "Forgot password?", action: #selector(forgotPasswordTapped), font: .systemFont(ofSize: 17), textColor: .mainGreen, backgroundColor: .clear)
    
    
    lazy var loginButton = Components.getButton(content: "Login", action: #selector(loginTapped), font: .systemFont(ofSize: 20), textColor: .white, backgroundColor: .mainGreen, size: 42)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Login"
        
        let tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapDismissKeyboard)
        
        setup()
        
        let mockUsers = AllUsers(users: [
            User(email: "email@email.com", password: "1234", fullName: "Felipe Elsner", balance: 2000, averageStars: 4.7, position: "Gerente de Projeto"),
            User(email: "email2@email.com", password: "1234", fullName: "Alex Fraga", balance: 1300, averageStars: 4.5, position: "Gerente de Projeto")
        ])
        UserDefaults.standard.set(try? JSONEncoder().encode(mockUsers), forKey: "all_users")

        registerForKeyboardNotifications(referenceView: passwordTextField)
    }

    deinit {
        unregisterForKeyboardNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    lazy var createAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account?"
        label.font = .systemFont(ofSize: 17)
        
        return label
    }()
    
    lazy var createAccountButton = Components.getButton(content: "Register", action: #selector(createAccountTapped), textColor: .mainGreen, backgroundColor: .clear)
    
    lazy var createAccountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createAccountLabel, createAccountButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var emailErrorLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Incorrect email"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.isHidden = true
        
        return label
    }()
    
    lazy var passwordErrorLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Wrong password"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.isHidden = true
        
        return label
    }()
    
    @objc func loginTapped() {
        if let user = Persistence.getUsers() {
            hideErrors()
            if let matchedUser = user.users.first(where: { $0.email == emailTextField.getText() && $0.password == passwordTextField.getText() }) {
                Persistence.updateLoggedUser(with: matchedUser)
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(TabBarController())
            } else {
                showError(for: passwordErrorLabel)
            }
        } else {
            showError(for: emailErrorLabel)
        }
    }
    
    @objc func createAccountTapped() {
        print("Create Account")
    }
    
    @objc func forgotPasswordTapped() {
        print("Forgot password tapped")
    }
    
    func showError(for label: UILabel) {
        label.isHidden = false
    }
    
    func hideErrors() {
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
}


