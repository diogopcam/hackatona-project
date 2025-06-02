//
//  StoreViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//


import UIKit

class StoreVC: UIViewController {
    
    let user = Persistence.getLoggedUser()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .backgroundPrimary
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(BenefitTableViewCell.self, forCellReuseIdentifier: BenefitTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "Your points: \(user?.balance ?? 0)"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let benefits: [Benefit] = [
        Benefit(name: "10% Discount - Green Restaurant", description: "Get 10% off any order", value: 500),
        Benefit(name: "Transport Credit", description: "$20 in public transport credits", value: 800),
        Benefit(name: "15% Discount - Sustainable Store", description: "15% off eco-friendly products", value: 650),
        Benefit(name: "Free Coffee", description: "One free drink at partner cafes", value: 300),
        Benefit(name: "20% Discount - Organic Products", description: "20% off organic food", value: 1000),
        Benefit(name: "Plant a Tree", description: "Contribute to planting a tree", value: 400),
        Benefit(name: "Sustainable Kit", description: "Kit with reusable products", value: 750),
        Benefit(name: "25% Discount - Bicycles", description: "25% off bike purchase or rental", value: 1200)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func getCategoryForBenefit(_ benefit: Benefit) -> String {
        if benefit.name.lowercased().contains("restaurant") || benefit.name.lowercased().contains("coffee") || benefit.name.lowercased().contains("organic") {
            return "Food"
        } else if benefit.name.lowercased().contains("transport") || benefit.name.lowercased().contains("bicycle") {
            return "Transport"
        } else if benefit.name.lowercased().contains("sustainable") || benefit.name.lowercased().contains("kit") {
            return "Sustainability"
        } else if benefit.name.lowercased().contains("tree") || benefit.name.lowercased().contains("plant") {
            return "Environment"
        } else {
            return "General"
        }
    }
    
    func getIconForBenefit(_ benefit: Benefit) -> String {
        let category = getCategoryForBenefit(benefit)
        switch category {
        case "Food":
            return benefit.name.lowercased().contains("coffee") ? "cup.and.saucer" : benefit.name.lowercased().contains("organic") ? "carrot" : "fork.knife"
        case "Transport":
            return benefit.name.lowercased().contains("bicycle") ? "bicycle" : "bus"
        case "Sustainability":
            return benefit.name.lowercased().contains("kit") ? "bag" : "leaf"
        case "Environment":
            return "tree"
        default:
            return "gift"
        }
    }
}
