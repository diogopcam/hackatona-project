//import UIKit
//
//class FeedbackViewController: UIViewController {
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Deixe seu feedback"
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Description"
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = .gray
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let fileLabel: UILabel = {
//        let label = UILabel()
//        label.text = "File:"
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let backButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Voltar", for: .normal)
//        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        button.tintColor = .systemBlue
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private let submitButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Fetto", for: .normal)
//        button.backgroundColor = .systemBlue
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 8
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private let feedbackTextView: UITextView = {
//        let textView = UITextView()
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.lightGray.cgColor
//        textView.layer.cornerRadius = 8
//        textView.font = UIFont.systemFont(ofSize: 16)
//        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        return textView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        setupConstraints()
//    }
//    
//    private func setupUI() {
//        view.addSubview(titleLabel)
//        view.addSubview(descriptionLabel)
//        view.addSubview(fileLabel)
//        view.addSubview(backButton)
//        view.addSubview(submitButton)
//        view.addSubview(feedbackTextView)
//        
//        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
//        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
//            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            fileLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
//            fileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            fileLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            feedbackTextView.topAnchor.constraint(equalTo: fileLabel.bottomAnchor, constant: 8),
//            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            feedbackTextView.heightAnchor.constraint(equalToConstant: 150),
//            
//            backButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 24),
//            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            backButton.widthAnchor.constraint(equalToConstant: 100),
//            backButton.heightAnchor.constraint(equalToConstant: 44),
//            
//            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 24),
//            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            submitButton.widthAnchor.constraint(equalToConstant: 100),
//            submitButton.heightAnchor.constraint(equalToConstant: 44)
//        ])
//    }
//    
//    @objc private func backButtonTapped() {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    @objc private func submitButtonTapped() {
//        guard !feedbackTextView.text.isEmpty else {
//            showAlert(message: "Por favor, digite seu feedback antes de enviar")
//            return
//        }
//        
//        // Aqui você pode implementar a lógica para enviar o feedback
//        print("Feedback enviado: \(feedbackTextView.text!)")
//        showAlert(message: "Feedback enviado com sucesso!")
//    }
//    
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
