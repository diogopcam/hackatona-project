//
//  FeedbackViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit
import AVFoundation

class CreateFeedbackVC: UIViewController {
    var employee: Employee?
    var resource: Resource?
    var activity: Activity?
    var audioRecorder: AVAudioRecorder?
    var isRecording = false
    var currentAudioURL: URL? // Esta é a variável que armazena o URL temporário da gravação
    private var feedbackTextView: UITextView!
    private let micButton: UIButton = {
           let button = UIButton(type: .system)
           let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
           let micImage = UIImage(systemName: "mic.fill", withConfiguration: config)
           button.setImage(micImage, for: .normal)
           button.tintColor = .white
           button.backgroundColor = .mainGreen
           button.layer.cornerRadius = 85
           button.clipsToBounds = true
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
    
    
    
    private var isAnonymous = false {
        didSet {
            anonymousToggle.isOn = isAnonymous
            updateAnonymousUI()
        }
    }
      
    private let anonymousToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private let anonymousLabel: UILabel = {
        let label = UILabel()
        label.text = "Anônimo"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var anonymousContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [anonymousToggle, anonymousLabel])
        view.axis = .horizontal
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc private func anonymousToggleChanged() {
            isAnonymous = anonymousToggle.isOn
        anonymousToggle.onTintColor = UIColor.mainGreen // cor do fundo quando ativado
    }
        
    private func updateAnonymousUI() {
        if isAnonymous {
            // Efeito visual para indicar modo anônimo
            imageView.alpha = 0.5
            descriptionLabel.alpha = 0.5
            infoLabel.alpha = 0.5
        } else {
            // Volta ao normal
            imageView.alpha = 1.0
            descriptionLabel.alpha = 1.0
            infoLabel.alpha = 1.0
        }
    }
    
    init(employee: Employee) {
        self.employee = employee
        super.init(nibName: nil, bundle: nil)
    }

    init(resource: Resource) {
        self.resource = resource
        super.init(nibName: nil, bundle: nil)
    }

    init(activity: Activity) {
        self.activity = activity
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
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        label.textColor = .primitiveWhite
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
//        view.backgroundColor = .white
        view.backgroundColor = .systemBackground
        
        
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if !granted {
                print("Permissão para usar o microfone negada")
            }
        }
        setupUI()
        setupConstraints()
        setupKeyboardDismissal()
        // Exemplo de conteúdo
                if let employee = employee {
                    print("Criando feedback para colaborador: \(employee.name)")
                } else if let resource = resource {
                    print("Criando feedback para recurso: \(resource.name)")
                } else if let activity = activity {
                    print("Criando feedback para atividade: \(activity.name)")
                }
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
//        
//        @objc private func dismissKeyboard() {
//            view.endEditing(true)
//        }
        
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
        // Adiciona os componentes ao container ANTES de adicionar à view
        view.addSubview(anonymousContainer)
        
        
        starRating.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starRating)

        view.addSubview(carouselScrollView)
        carouselScrollView.addSubview(carouselStackView)
        view.addSubview(submitButton)
        
        // Adiciona os itens ao carrossel
        feedbackTextView = addTextItem(title: "Deixe um feedback escrito")
        addAudioItem(title: "Grave um feedback de voz")
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 130),
            imageView.heightAnchor.constraint(equalToConstant: 130),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
//            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            anonymousContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -32),
            anonymousContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            
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
    
    private func addTextItem(title: String) -> UITextView {
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        itemView.backgroundColor = .systemBackground
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
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = .primitiveWhite
        textView.backgroundColor = .systemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        itemView.addSubview(label)
        itemView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 24),
            label.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
            textView.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: -24)
        ])
        
        carouselStackView.addArrangedSubview(itemView)
        itemView.widthAnchor.constraint(equalTo: carouselScrollView.widthAnchor, constant: -32).isActive = true
        
        return textView
    }
    
    private func addAudioItem(title: String) {
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        itemView.backgroundColor = .systemBackground
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
        
       
        // Remove a declaração local do micButton e usa a propriedade da classe
            micButton.addTarget(self, action: #selector(didTapMicButton), for: .touchUpInside)
            
            itemView.addSubview(label)
            itemView.addSubview(micButton) // Agora usando a propriedade
            
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 24),
            label.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
            
            micButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            micButton.centerXAnchor.constraint(equalTo: itemView.centerXAnchor),
//            micButton.centerYAnchor.constraint(equalTo: itemView.centerYAnchor),
            micButton.widthAnchor.constraint(equalToConstant: 170),
            micButton.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        carouselStackView.addArrangedSubview(itemView)
        itemView.widthAnchor.constraint(equalTo: carouselScrollView.widthAnchor, constant: -32).isActive = true
    }
    
    @objc private func didTapMicButton() {
        if isRecording {
            stopRecording()
            UIView.animate(withDuration: 0.3) {
                self.micButton.transform = .identity
                self.micButton.backgroundColor = .mainGreen
            }
        } else {
            startRecording()
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut,
                           animations: {
                self.micButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.micButton.backgroundColor = .systemRed
            })
        }
        isRecording.toggle()
    }
    
    private func animateMicButton(scale: CGFloat) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
            
            self.micButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // Mudança de cor opcional para feedback visual adicional
            if scale > 1.0 {
                self.micButton.backgroundColor = .systemRed // Vermelho durante gravação
            } else {
                self.micButton.backgroundColor = .mainGreen // Verde quando não está gravando
            }
        })
    }

        private func startRecording() {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default)
                try audioSession.setActive(true)
                
                let tempDir = FileManager.default.temporaryDirectory
                let fileURL = tempDir.appendingPathComponent(UUID().uuidString + ".m4a")
                currentAudioURL = fileURL
                
                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
                audioRecorder?.record()
                print("🎙️ Gravando em: \(fileURL)")
            } catch {
                print("Erro ao iniciar gravação: \(error.localizedDescription)")
            }
        }

        private func stopRecording() {
            audioRecorder?.stop()
            print("🛑 Gravação finalizada.")
            if let url = currentAudioURL {
                print("🔊 Arquivo de áudio salvo em: \(url)")
                currentAudioURL = url
            }
        }
    
    @objc private func submitButtonTapped() {
        let feedbackText = feedbackTextView.text ?? ""
        let rating = starRating.rating
        let audioURL = currentAudioURL
        let senderID = "user_123"     // <- ID do remetente
        let receiverID = "carla_001"  // <- ID da Carla
        let audioFileName = UUID().uuidString + ".m4a"

        var audioData: Data? = nil
        if let url = audioURL {
            audioData = try? Data(contentsOf: url)
        }

        let feedback = Feedback(
            stars: rating,
            description: feedbackText,
            senderID: senderID,
            receiverID: receiverID,
            midia: audioData != nil ? audioFileName : nil
        )
        
        GlobalData.balance += 10
        GlobalData.totalPoints += 10

        FeedbackManager.shared.saveFeedback(feedback, audioData: audioData)
        FeedbackManager.shared.printAllFeedbacks()

        print("✅ Feedback salvo com sucesso!")
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

extension CreateFeedbackVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Não dispara o gesto se o toque foi em um controle interativo
        return !(touch.view is UIControl)
    }
}
