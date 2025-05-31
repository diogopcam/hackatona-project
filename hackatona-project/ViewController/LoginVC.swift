//
//  LoginViewController.swift
//  Incentiv8
//
//  Created by João Pedro Teixeira de Caralho on 13/05/25.
//
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Icon image
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profileImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    // MARK: Title
    lazy var titleLabel = Components.getLabel(content: "Welcome", font: .systemFont(ofSize: 48, weight: .bold))
    
    // MARK: Email
    lazy var emailTextField = NamedTextField(title: "Email", placeholder: "abc@abc.com")
    
    
    // MARK: Password
    lazy var passwordTextField = NamedTextField(title: "Password", placeholder: "********", isPassword: true)
    
    
    // MARK: Fields stack
    lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    //MARK: Forgot password button
    lazy var forgotPasswordButton = Components.getButton(content: "Forgot password?", action: #selector(forgotPasswordTapped), font: .systemFont(ofSize: 17), textColor: .mainGreen, backgroundColor: .clear)
    
    
    // MARK: Login button
    lazy var loginButton = Components.getButton(content: "Login", action: #selector(loginTapped), font: .systemFont(ofSize: 20), textColor: .white, backgroundColor: .mainGreen, size: 42)
    
    
    // MARK: Scene
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
    
    
    // MARK: Create account label + button
    lazy var createAccountLabel = Components.getLabel(content: "Don't have an account?")
    
    lazy var createAccountButton = Components.getButton(content: "Register", action: #selector(createAccountTapped), textColor: .mainGreen, backgroundColor: .clear)
    
    lazy var createAccountStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createAccountLabel, createAccountButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    // MARK: Error messages
    lazy var emailErrorLabel = Components.getLabel(content: "Incorrect email", font: .systemFont(ofSize: 13), textColor: .systemRed, alignment: .left, hiden: true)
    lazy var passwordErrorLabel = Components.getLabel(content: "Wrong password", font: .systemFont(ofSize: 13), textColor: .systemRed, alignment: .left, hiden: true)
    
    
    // MARK: Button functions
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
//        navigationController?.pushViewController(CreateAccountViewController(), animated: true)
    }
    
    @objc func forgotPasswordTapped() {
        print("Forgot password tapped")
    }
    
    // MARK: General functions
    func showError(for label: UILabel) {
        label.isHidden = false
    }
    
    func hideErrors() {
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
}

// MARK: View Code Protocol
extension LoginViewController: ViewCodeProtocol {
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
            
            // Icon
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 154),
            iconImageView.widthAnchor.constraint(equalToConstant: 154),
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 68),
            
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 33),
            
            // Fields stack
            fieldsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            fieldsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            fieldsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 83),
            
            //Error messages
            emailErrorLabel.leadingAnchor.constraint(equalTo: fieldsStackView.leadingAnchor),
            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: fieldsStackView.leadingAnchor),
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            
            // Forgot password button
            forgotPasswordButton.trailingAnchor.constraint(equalTo: fieldsStackView.trailingAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor),
            
            // Login button
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 71),
            
            // Create account
            createAccountStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 32),
        ])
    }
    
    
}


