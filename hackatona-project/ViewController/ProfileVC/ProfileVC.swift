//
//  ProfileViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//

import UIKit

class ProfileVC: UIViewController {
    
    lazy var headerView = ProfileHeader()
    
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
