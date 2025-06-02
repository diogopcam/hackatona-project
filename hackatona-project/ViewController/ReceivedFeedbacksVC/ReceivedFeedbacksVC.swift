//
//  ReceivedFeedbacksVC.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//

import UIKit

class ReceivedFeedbacksVC: UIViewController {
    
    lazy var tableView: UITableView = {
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
