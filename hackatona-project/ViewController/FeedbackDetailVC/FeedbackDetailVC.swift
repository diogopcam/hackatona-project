import UIKit
import AVFoundation

class FeedBackDetailsVC: UIViewController {
    var feedback: Feedback?
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    
    init(feedback: Feedback) {
        self.feedback = feedback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .mainGreen
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Nome"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .primitiveWhite
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Cargo"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .primitiveWhite
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starRating = StarRatingView()
    
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Texto"
        textView.isEditable = false
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 24)
        textView.textColor = .primitiveWhite
        textView.backgroundColor = .backgroundPrimary
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var audioButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let micImage = UIImage(systemName: "play.fill", withConfiguration: config)
        button.setImage(micImage, for: .normal)
        button.tintColor = .labelPrimary
        button.backgroundColor = .mainGreen
        button.layer.cornerRadius = 85
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundPrimary
        view.layer.cornerRadius = 12
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
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
        
        if let senderName = feedback.senderName {
            descriptionLabel.text = senderName
        }
        if let senderPosition = feedback.senderPosition {
            infoLabel.text = senderPosition
        }
        
        starRating.rating = feedback.stars
        
        imageView.subviews.forEach { $0.removeFromSuperview() }
        let name = feedback.senderName ?? "Anônimo"
        
        if let photoURL = feedback.senderPhoto, let url = URL(string: photoURL) {
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
        
        starRating.isEditable = false
        starRating.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starRating)
        
        containerView.addSubview(textView)
    }
    
    private func setupAudioView() {
        containerView.addSubview(audioButton)
        
        audioButton.addTarget(self, action: #selector(audioButtonTapped), for: .touchUpInside)
        
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
    
    // MARK: - Audio Player Functions
    @objc private func audioButtonTapped() {
        guard let feedback = feedback, let audioFileName = feedback.midia else {
            showAlert(message: "Nenhum arquivo de áudio disponível")
            return
        }
        
        if isPlaying {
            stopAudio()
        } else {
            playAudio(fileName: audioFileName)
        }
    }
    
    private func playAudio(fileName: String) {
        print("🎵 Tentando reproduzir áudio: \(fileName)")
        
        guard let audioURL = AudioFileManager.shared.getAudioFileURL(fileName: fileName) else {
            print("❌ Arquivo de áudio não encontrado: \(fileName)")
            showAlert(message: "Arquivo de áudio não encontrado: \(fileName)")
            return
        }
        
        print("✅ Arquivo encontrado em: \(audioURL.path)")
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            let success = audioPlayer?.play() ?? false
            print("🔊 Reprodução iniciada: \(success)")
            
            if success {
                isPlaying = true
                updateAudioButton()
            } else {
                print("❌ Falha ao iniciar reprodução")
                showAlert(message: "Falha ao iniciar reprodução do áudio")
            }
            
        } catch {
            print("❌ Erro ao reproduzir áudio: \(error)")
            showAlert(message: "Erro ao reproduzir áudio: \(error.localizedDescription)")
        }
    }
    
    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        updateAudioButton()
    }
    
    private func updateAudioButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let imageName = isPlaying ? "stop.fill" : "play.fill"
        let image = UIImage(systemName: imageName, withConfiguration: config)
        audioButton.setImage(image, for: .normal)
    }
}

extension FeedBackDetailsVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        updateAudioButton()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        updateAudioButton()
        if let error = error {
            showAlert(message: "Erro na decodificação do áudio: \(error.localizedDescription)")
        }
    }
}
