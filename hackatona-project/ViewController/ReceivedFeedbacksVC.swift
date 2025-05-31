//
//  ReceivedFeedbacksVC.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//

import UIKit

class ReceivedFeedbacksVC: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Feedbacks Recebidos"
        view.backgroundColor = .black
        setup()
        
        // Mock temporário
        receivedFeedbacks = [
            Feedback(stars: 5, description: "Mandou muito bem na liderança do grupo!", senderID: "234", receiverID: "123", midia: nil),
            Feedback(stars: 4, description: "Boa comunicação, continuaria trabalhando com você.", senderID: "345", receiverID: "123", midia: "feedback1.m4a"),
            Feedback(stars: 3, description: "Cumpriu as tarefas, mas poderia ter participado mais nas discussões.", senderID: "456", receiverID: "123", midia: nil)
        ]
    }

    
}

extension ReceivedFeedbacksVC: ViewCodeProtocol {
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

extension ReceivedFeedbacksVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivedFeedbacks.isEmpty ? 1 : receivedFeedbacks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if receivedFeedbacks.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyTableViewCell
            cell.config(0) // seção 0 = recebidos
            cell.backgroundColor = .clear
            return cell
        }
        
        let feedback = receivedFeedbacks[indexPath.row]
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
            image: UIImage(systemName: "trophy")!,
            text: "Feedbacks recebidos",
            button: nil,
            backgroundColor: .systemBackground
        )
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
