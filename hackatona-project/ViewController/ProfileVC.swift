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
        setup()
        
        self.receivedFeedbacks = [
            Feedback(stars: 5, description: "Mandou muito bem na liderança do grupo!", senderID: "234", receiverID: "123", midia: nil),
            Feedback(stars: 4, description: "Boa comunicação, continuaria trabalhando com você.", senderID: "345", receiverID: "123", midia: "feedback1.m4a"),
            Feedback(stars: 3, description: "Cumpriu as tarefas, mas poderia ter participado mais nas discussões.", senderID: "456", receiverID: "123", midia: nil)
        ]
        
        self.sendedFeedbacks = [
            Feedback(stars: 5, description: "Excelente trabalho técnico, sempre disposto a ajudar!", senderID: "123", receiverID: "789", midia: "elogio_tecnico.m4a"),
            Feedback(stars: 2, description: "Faltou engajamento no projeto, vamos tentar melhorar!", senderID: "123", receiverID: "654", midia: nil),
            Feedback(stars: 4, description: "Criatividade foi um destaque, boas sugestões!", senderID: "123", receiverID: "321", midia: nil)
        ]
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
        let name = "Usuário Exemplo" // TODO: Substituir pelo nome real se disponível
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