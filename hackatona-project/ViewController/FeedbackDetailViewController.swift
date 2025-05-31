import UIKit
import AVFoundation

class FeedbackDetailViewController: UIViewController {
    var feedback: Feedback?
    
    init(feedback: Feedback) {
        self.feedback = feedback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        label.textColor = .primitiveWhite
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Cargo"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .primitiveWhite
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starRating = StarRatingView()
    
    // Componentes para feedback de texto
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Texto"
        textView.isEditable = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = .primitiveWhite
        textView.backgroundColor = .systemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // Componentes para feedback de áudio
    private lazy var audioButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let micImage = UIImage(systemName: "play.fill", withConfiguration: config)
        button.setImage(micImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .mainGreen
        button.layer.cornerRadius = 85
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        loadFeedbackData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    private func loadFeedbackData() {
        guard let feedback = feedback else { return }
        
        // Set name and position based on the feedback data
        if let senderName = feedback.senderName {
            descriptionLabel.text = senderName
        }
        if let senderPosition = feedback.senderPosition {
            infoLabel.text = senderPosition
        }
        
        starRating.rating = feedback.stars
        
        // Configure image view with first letter if no photo
        imageView.subviews.forEach { $0.removeFromSuperview() }
        let name = feedback.senderName ?? "Anônimo"
        
        if let photoURL = feedback.senderPhoto, let url = URL(string: photoURL) {
            // Show loading state with first letter while image loads
            showFirstLetterPlaceholder(for: name)
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageView.subviews.forEach { $0.removeFromSuperview() }
                    self.imageView.image = image
                }
            }.resume()
        } else {
            showFirstLetterPlaceholder(for: name)
        }
        
        if let audio = feedback.midia, audio.hasSuffix(".m4a") {
            // Configuração para feedback de áudio
            textView.removeFromSuperview()
            setupAudioView()
        } else if !feedback.description.isEmpty {
            audioButton.removeFromSuperview()
            textView.text = feedback.description
        }
    }
    
    private func showFirstLetterPlaceholder(for name: String) {
        let firstLetter = String(name.prefix(1)).uppercased()
        let label = UILabel()
        label.text = firstLetter
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.frame = imageView.bounds
        imageView.image = nil
        imageView.addSubview(label)
    }
    
    private func setupUI() {
        view.addSubview(descriptionLabel)
        view.addSubview(infoLabel)
        view.addSubview(imageView)
        view.addSubview(containerView)
        
        starRating.isEditable = false // ou true, conforme desejado
        starRating.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starRating)
        
        // Adiciona inicialmente o textView (pode ser removido depois se for áudio)
        containerView.addSubview(textView)
    }
    
    private func setupAudioView() {
        containerView.addSubview(audioButton)
        
        NSLayoutConstraint.activate([
            audioButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            audioButton.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 40),
            audioButton.widthAnchor.constraint(equalToConstant: 170),
            audioButton.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
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
            
            containerView.topAnchor.constraint(equalTo: starRating.bottomAnchor, constant: 32),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
