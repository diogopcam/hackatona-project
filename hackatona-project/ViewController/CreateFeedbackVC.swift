//
//  FeedbackViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

class CreateFeedbackVC: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .mainGreen
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Cargo"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    let starRating = StarRatingView()
    
    private let carouselScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let carouselStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enviar", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .mainGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        setupKeyboardDismissal()
    }
    
    // MARK: - Keyboard Dismissal Setup
        private func setupKeyboardDismissal() {
            // Configura o gesture recognizer para toque na tela
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false // Permite que outros gestos/touches funcionem normalmente
            view.addGestureRecognizer(tapGesture)
            
            // Observadores para teclado (opcional, mas recomendado)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        @objc private func dismissKeyboard() {
            view.endEditing(true)
        }
        
        // MARK: - Keyboard Handling (Opcional mas útil)
        @objc private func keyboardWillShow(notification: NSNotification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
        
        @objc private func keyboardWillHide(notification: NSNotification) {
            scrollView.contentInset = .zero
            scrollView.verticalScrollIndicatorInsets = .zero
        }
        
        // MARK: - TextView Delegate
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            // Rola para a textView quando ela começa a edição
            DispatchQueue.main.async {
                let rect = textView.convert(textView.bounds, to: self.scrollView)
                self.scrollView.scrollRectToVisible(rect, animated: true)
            }
            return true
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    private func setupUI() {
        view.addSubview(descriptionLabel)
        view.addSubview(infoLabel)
        view.addSubview(imageView)
        
        starRating.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starRating)

        view.addSubview(carouselScrollView)
        carouselScrollView.addSubview(carouselStackView)
        view.addSubview(submitButton)
        
        // Adiciona os itens ao carrossel
        addTextItem(title: "Deixe um feedback escrito")
        addAudioItem(title: "Grave um feedback de voz")
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 130),
            imageView.heightAnchor.constraint(equalToConstant: 130),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            starRating.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starRating.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            starRating.heightAnchor.constraint(equalToConstant: 40),
            starRating.widthAnchor.constraint(equalToConstant: 230),
            
            carouselScrollView.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 0),
            carouselScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselScrollView.heightAnchor.constraint(equalToConstant: 350),
            
            carouselStackView.topAnchor.constraint(equalTo: carouselScrollView.topAnchor),
            carouselStackView.bottomAnchor.constraint(equalTo: carouselScrollView.bottomAnchor),
            carouselStackView.leadingAnchor.constraint(equalTo: carouselScrollView.leadingAnchor, constant: 16),
            carouselStackView.trailingAnchor.constraint(equalTo: carouselScrollView.trailingAnchor, constant: -16),
            carouselStackView.heightAnchor.constraint(equalToConstant: 300),
            
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    private func addTextItem(title: String) {
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        itemView.backgroundColor = .white
        itemView.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = .black // Cor da fonte (pode usar qualquer cor)
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        itemView.addSubview(label)
        itemView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: -24)
        ])
        
        carouselStackView.addArrangedSubview(itemView)
        itemView.widthAnchor.constraint(equalTo: carouselScrollView.widthAnchor, constant: -32).isActive = true
    }
    
    private func addAudioItem(title: String) {
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        itemView.backgroundColor = .white
        itemView.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let micButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let micImage = UIImage(systemName: "mic.fill", withConfiguration: config)
        micButton.setImage(micImage, for: .normal)
        micButton.tintColor = .white
        micButton.backgroundColor = .mainGreen
        micButton.layer.cornerRadius = 85
        micButton.clipsToBounds = true
        micButton.translatesAutoresizingMaskIntoConstraints = false
        
        itemView.addSubview(label)
        itemView.addSubview(micButton)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 24),
            label.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            
            micButton.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            micButton.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            micButton.widthAnchor.constraint(equalToConstant: 170),
            micButton.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        carouselStackView.addArrangedSubview(itemView)
        itemView.widthAnchor.constraint(equalTo: carouselScrollView.widthAnchor, constant: -32).isActive = true
    }
    
    @objc private func submitButtonTapped() {
        showAlert(message: "Feedback enviado com sucesso!")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension CreateFeedbackVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Não dispara o gesto se o toque foi em um controle interativo
        return !(touch.view is UIControl)
    }
}
