//
//  SendedFeedbacksVC.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//

import UIKit

class SendedFeedbacksVC: UIViewController {

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

    var sendedFeedbacks: [Feedback] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup()

        // Mock temporário
        sendedFeedbacks = [
            Feedback(stars: 5, description: "Excelente trabalho técnico, sempre disposto a ajudar!", senderID: "123", receiverID: "789", midia: "elogio_tecnico.m4a"),
            Feedback(stars: 2, description: "Faltou engajamento no projeto, vamos tentar melhorar!", senderID: "123", receiverID: "654", midia: nil),
            Feedback(stars: 4, description: "Criatividade foi um destaque, boas sugestões!", senderID: "123", receiverID: "321", midia: nil)
        ]
    }
}

extension SendedFeedbacksVC: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(tableView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SendedFeedbacksVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sendedFeedbacks.isEmpty ? 1 : sendedFeedbacks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sendedFeedbacks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyTableViewCell
            cell.config(1) // seção 1 = enviados
            cell.backgroundColor = .clear
            return cell
        }

        let feedback = sendedFeedbacks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedbackCell", for: indexPath) as! FeedbackTableViewCell
        let name = "Usuário Exemplo" // TODO: pegar nome real
        cell.config(feedback, name: name)
        cell.backgroundColor = .clear
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return GenericTableViewHeader(
            image: UIImage(systemName: "paperplane")!,
            text: "Feedbacks enviados",
            button: nil,
            backgroundColor: .systemBackground
        )
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
