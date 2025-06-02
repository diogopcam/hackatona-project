//
//  SendedFeedbacksVC.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//

import UIKit

class SendedFeedbacksVC: UIViewController {

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .backgroundSecondary
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

        sendedFeedbacks = [
            Feedback(stars: 5, description: "Excelente trabalho técnico, sempre disposto a ajudar!", senderID: "123", receiverID: "789", midia: "elogio_tecnico.m4a"),
            Feedback(stars: 2, description: "Faltou engajamento no projeto, vamos tentar melhorar!", senderID: "123", receiverID: "654", midia: nil),
            Feedback(stars: 4, description: "Criatividade foi um destaque, boas sugestões!", senderID: "123", receiverID: "321", midia: nil)
        ]
    }
}
