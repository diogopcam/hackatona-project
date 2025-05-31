//
//  ProfileViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var headerView = ProfileHeader()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .mainGreen
        setupLogoutButton()
        setup()
        
        // Mock data with real users
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

// MARK: - UITableViewDelegate

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

// MARK: - Actions

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

// MARK: - ViewCode

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
