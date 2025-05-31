//
//  ProfileViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var headerView = ProfileHeader()
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            refreshGlobalState()
        }
        
        private func refreshGlobalState() {
            // Atualiza o header com os valores mais recentes
            headerView.update()
            
            // Se precisar atualizar outros dados baseados no GlobalState:
//            tableView.reloadData()
        }
    
    func update() {
        headerView.balanceLabel.text = "Saldo: \(GlobalData.balance)"
        headerView.totalPointsLabel.text = "Total: \(GlobalData.totalPoints)"
       // Adicione outras atualizações de UI necessárias
    }

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(FeedbackTableViewCell.self, forCellReuseIdentifier: "FeedbackCell")
        table.register(EmptyTableViewCell.self, forCellReuseIdentifier: "EmptyCell")
        return table
    }()
    
    var receivedFeedbacks: [Feedback] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var sendedFeedbacks: [Feedback] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    @objc private func updateHeader() {
        headerView.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshGlobalState()
        
        
        navigationController?.navigationBar.tintColor = .mainGreen
        setupLogoutButton()
        setup()
        
        // Obter o arquivo de áudio mais recente gravado pelo usuário
        let mostRecentAudio = AudioFileManager.shared.getMostRecentRecordedAudio()
        
        // Obter outros arquivos de áudio disponíveis
        let availableAudioFiles = AudioFileManager.shared.getSampleAudioFiles()
        
        // Atribua os arrays às propriedades da classe usando arquivos reais
        // O primeiro feedback sempre usará o áudio mais recente do usuário
        self.receivedFeedbacks = [
            Feedback(stars: 5, description: "Mandou muito bem na liderança do grupo!", senderID: "234", receiverID: "123", midia: mostRecentAudio ?? (availableAudioFiles.count > 0 ? availableAudioFiles[0] : nil)),
            Feedback(stars: 4, description: "Boa comunicação, continuaria trabalhando com você.", senderID: "345", receiverID: "123", midia: availableAudioFiles.count > 1 ? availableAudioFiles[1] : nil),
            Feedback(stars: 3, description: "Cumpriu as tarefas, mas poderia ter participado mais nas discussões.", senderID: "456", receiverID: "123", midia: availableAudioFiles.count > 2 ? availableAudioFiles[2] : nil)
        ]
        
        self.sendedFeedbacks = [
            Feedback(stars: 5, description: "Excelente trabalho técnico, sempre disposto a ajudar!", senderID: "123", receiverID: "789", midia: availableAudioFiles.count > 3 ? availableAudioFiles[3] : nil),
            Feedback(stars: 2, description: "Faltou engajamento no projeto, vamos tentar melhorar!", senderID: "123", receiverID: "654", midia: availableAudioFiles.count > 4 ? availableAudioFiles[4] : nil),
            Feedback(stars: 4, description: "Criatividade foi um destaque, boas sugestões!", senderID: "123", receiverID: "321", midia: availableAudioFiles.count > 5 ? availableAudioFiles[5] : AudioFileManager.shared.getRandomAudioFile())
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Atualizar feedbacks com o áudio mais recente quando a tela aparecer
        updateFeedbacksWithLatestAudio()
    }
    
    private func updateFeedbacksWithLatestAudio() {
        // Obter o arquivo de áudio mais recente gravado pelo usuário
        let mostRecentAudio = AudioFileManager.shared.getMostRecentRecordedAudio()
        
        // Se há um novo áudio, atualizar o primeiro feedback
        if let latestAudio = mostRecentAudio, 
           !receivedFeedbacks.isEmpty {
            
            var updatedFeedbacks = receivedFeedbacks
            updatedFeedbacks[0] = Feedback(
                stars: updatedFeedbacks[0].stars,
                description: "Mandou muito bem na liderança do grupo! (Áudio atualizado)",
                senderID: updatedFeedbacks[0].senderID,
                receiverID: updatedFeedbacks[0].receiverID,
                midia: latestAudio
            )
            
            self.receivedFeedbacks = updatedFeedbacks
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Debug: Listar todos os arquivos de áudio disponíveis
        debugAudioFiles()
    }
    
    private func debugAudioFiles() {
        print("🔍 === DEBUG AUDIO FILES ===")
        
        let allFiles = AudioFileManager.shared.listAllAudioFiles()
        print("📁 Arquivos .m4a encontrados: \(allFiles)")
        
        let recordedFiles = AudioFileManager.shared.getRecordedAudios()
        print("📋 Arquivos registrados: \(recordedFiles)")
        
        let mostRecent = AudioFileManager.shared.getMostRecentRecordedAudio()
        print("🎵 Áudio mais recente: \(mostRecent ?? "nil")")
        
        print("🎯 Primeiro feedback usa áudio: \(receivedFeedbacks.first?.midia ?? "nil")")
        print("=========================")
      
        self.receivedFeedbacks = [
            Feedback(
                stars: 5,
                description: "Excelente liderança no projeto da Hackatona! Sua dedicação em manter a equipe focada foi fundamental.",
                senderID: "felipe_id",
                receiverID: "current_user",
                midia: nil,
                senderName: "Eduardo Camana",
                senderPosition: "QA Analyst",
                senderPhoto: "https://media.licdn.com/dms/image/v2/D4D03AQHcwDN2s22pAA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1700490727729?e=1753920000&v=beta&t=spO6ekf4ssq4rVJ2NPlgjgVpsuOFEQBUDlm4eaBjv_s"
            ),
            Feedback(
                stars: 4,
                description: "Ótimo trabalho na implementação das features de UI/UX. O app ficou muito intuitivo!",
                senderID: "diogo_id",
                receiverID: "current_user",
                midia: "feedback_audio.m4a",
                senderName: "Diogo Camargo",
                senderPosition: "iOS Developer",
                senderPhoto: "https://media.licdn.com/dms/image/D4D03AQEn3kHJyUl97A/profile-displayphoto-shrink_800_800/0/1693339774298?e=1709769600&v=beta&t=v9I5RO2Sb3qJYxBPXHEHhZPqBxZAqvZOTVJHmFkBVvY"
            ),
            Feedback(
                stars: 5,
                description: "Sua contribuição na arquitetura do projeto foi essencial. Clean code e boas práticas sempre!",
                senderID: "eduardo_id",
                receiverID: "current_user",
                midia: nil,
                senderName: "Eduardo Camana",
                senderPosition: "Software Engineer",
                senderPhoto: "https://media.licdn.com/dms/image/v2/D4D03AQHcwDN2s22pAA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1700490727729?e=1753920000&v=beta&t=spO6ekf4ssq4rVJ2NPlgjgVpsuOFEQBUDlm4eaBjv_s"
            )
        ]
        
        self.sendedFeedbacks = [
            Feedback(
                stars: 5,
                description: "Incrível como você conseguiu organizar toda a estrutura do projeto! Seu conhecimento técnico é inspirador.",
                senderID: "current_user",
                receiverID: "felipe_id",
                midia: "audio_feedback.m4a",
                receiverName: "Felipe Elsner",
                receiverPosition: "Tech Lead",
                receiverPhoto: "https://media.licdn.com/dms/image/D4D03AQGjPnWPzJr6Yw/profile-displayphoto-shrink_800_800/0/1696428504560?e=1709769600&v=beta&t=Yx_0RZNkHUVvdXUrwgJvTI5VVXc6Yl8FQjYKpuPF7Hs"
            ),
            Feedback(
                stars: 5,
                description: "Excelente trabalho na implementação do QR Code e câmera. Features complexas entregues com qualidade!",
                senderID: "current_user",
                receiverID: "diogo_id",
                midia: nil,
                receiverName: "Diogo Camargo",
                receiverPosition: "iOS Developer",
                receiverPhoto: "https://media.licdn.com/dms/image/D4D03AQEn3kHJyUl97A/profile-displayphoto-shrink_800_800/0/1693339774298?e=1709769600&v=beta&t=v9I5RO2Sb3qJYxBPXHEHhZPqBxZAqvZOTVJHmFkBVvY"
            ),
            Feedback(
                stars: 5,
                description: "Sua visão de arquitetura e padrões de projeto elevou muito a qualidade do código!",
                senderID: "current_user",
                receiverID: "eduardo_id",
                midia: nil,
                receiverName: "Eduardo Camana",
                receiverPosition: "Software Engineer",
                receiverPhoto: "https://media.licdn.com/dms/image/v2/D4D03AQHcwDN2s22pAA/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1700490727729?e=1753920000&v=beta&t=spO6ekf4ssq4rVJ2NPlgjgVpsuOFEQBUDlm4eaBjv_s"
            )
        ]
    }

    private func setupLogoutButton() {
        let logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
            
        )
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "Sair",
            message: "Tem certeza que deseja sair?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Sair", style: .destructive) { [weak self] _ in
            // Remove user data
            UserDefaults.standard.removeObject(forKey: "logged_user")
            UserDefaults.standard.synchronize()
            
            // Present login screen
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.showLogin()
            }
        })
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? receivedFeedbacks : sendedFeedbacks).isEmpty ? 1 : (section == 0 ? receivedFeedbacks.count : sendedFeedbacks.count)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return GenericTableViewHeader(
                image: UIImage(systemName: "trophy")!,
                text: "Feedbacks recebidos",
                button: Components.getTextButton(
                    title: "Ver todos",
                    action: #selector(seeAllReceived)
                ),
                backgroundColor: .systemBackground
            )
        } else {
            return GenericTableViewHeader(
                image: UIImage(systemName: "paperplane")!,
                text: "Feedbacks enviados",
                button: Components.getTextButton(
                    title: "Ver todos",
                    action: #selector(seeAllSended)
                ),
                backgroundColor: .systemBackground
            )
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let feedbacks = section == 0 ? receivedFeedbacks : sendedFeedbacks

        if feedbacks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyTableViewCell
            cell.config(section)
            cell.backgroundColor = .clear
            return cell
        }

        let feedback = feedbacks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackTableViewCell
        
        // Use the sender/receiver name from the feedback
        let name = section == 0 ? feedback.senderName ?? "Anônimo" : feedback.receiverName ?? "Anônimo"
        cell.config(feedback, name: name)
        cell.backgroundColor = .clear
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let feedbacks = indexPath.section == 0 ? receivedFeedbacks : sendedFeedbacks

        guard !feedbacks.isEmpty else { return }

        let feedback = feedbacks[indexPath.row]
        let detailVC = FeedbackDetailViewController(feedback: feedback)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 12
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)

        cell.contentView.layer.cornerRadius = 0
        cell.contentView.layer.maskedCorners = []

        if indexPath.row == 0 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }

        if indexPath.row == totalRows - 1 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: cell.bounds.width,
                bottom: 0,
                right: 0
            )
        }

        if totalRows == 1 {
            cell.contentView.layer.cornerRadius = cornerRadius
            cell.contentView.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner,
                .layerMinXMaxYCorner, .layerMaxXMaxYCorner,
            ]
        }

        cell.contentView.layer.masksToBounds = true
    }
    
    
}

extension ProfileViewController {
    @objc func seeAllReceived() {
        let vc = ReceivedFeedbacksVC()
                       navigationController?.pushViewController(vc, animated: true)
    }

    @objc func seeAllSended() {
        let vc = SendedFeedbacksVC()
                       navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(headerView)
        view.addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.backgroundColor = .black
        headerView.translatesAutoresizingMaskIntoConstraints = false
    }
}
