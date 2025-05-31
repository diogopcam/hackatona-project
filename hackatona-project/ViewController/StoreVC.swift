

//
//  StoreViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//


import UIKit

class StoreViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .backgroundPrimary
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(BenefitCell.self, forCellReuseIdentifier: BenefitCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPrimary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "Seus pontos: 1,670"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let benefits: [Benefit] = [
        Benefit(name: "Desconto 10% - Restaurante Verde", description: "Ganhe 10% de desconto em qualquer pedido", value: 500),
        Benefit(name: "Vale Transporte", description: "R$ 20 em créditos para transporte público", value: 800),
        Benefit(name: "Desconto 15% - Loja Sustentável", description: "15% off em produtos eco-friendly", value: 650),
        Benefit(name: "Café Grátis", description: "Uma bebida grátis em cafeterias parceiras", value: 300),
        Benefit(name: "Desconto 20% - Produtos Orgânicos", description: "20% de desconto em alimentos orgânicos", value: 1000),
        Benefit(name: "Plantio de Árvore", description: "Contribua para o plantio de uma árvore", value: 400),
        Benefit(name: "Kit Sustentável", description: "Kit com produtos reutilizáveis", value: 750),
        Benefit(name: "Desconto 25% - Bicicletas", description: "25% off na compra ou aluguel de bikes", value: 1200)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func getCategoryForBenefit(_ benefit: Benefit) -> String {
        if benefit.name.lowercased().contains("restaurante") || benefit.name.lowercased().contains("café") || benefit.name.lowercased().contains("orgânico") {
            return "Alimentação"
        } else if benefit.name.lowercased().contains("transporte") || benefit.name.lowercased().contains("bicicleta") {
            return "Transporte"
        } else if benefit.name.lowercased().contains("sustentável") || benefit.name.lowercased().contains("kit") {
            return "Sustentabilidade"
        } else if benefit.name.lowercased().contains("árvore") || benefit.name.lowercased().contains("plantio") {
            return "Meio Ambiente"
        } else {
            return "Geral"
        }
    }
    
    private func getIconForBenefit(_ benefit: Benefit) -> String {
        let category = getCategoryForBenefit(benefit)
        switch category {
        case "Alimentação":
            return benefit.name.lowercased().contains("café") ? "cup.and.saucer" : benefit.name.lowercased().contains("orgânico") ? "carrot" : "fork.knife"
        case "Transporte":
            return benefit.name.lowercased().contains("bicicleta") ? "bicycle" : "bus"
        case "Sustentabilidade":
            return benefit.name.lowercased().contains("kit") ? "bag" : "leaf"
        case "Meio Ambiente":
            return "tree"
        default:
            return "gift"
        }
    }
}

extension StoreViewController: ViewCodeProtocol {
    func addSubViews() {
        title = "Loja"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .backgroundPrimary
        
        view.addSubview(headerView)
        headerView.addSubview(pointsLabel)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 120),
//
            pointsLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            pointsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension StoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return benefits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BenefitCell.identifier, for: indexPath) as? BenefitCell else {
            return UITableViewCell()
        }
        
        let benefit = benefits[indexPath.row]
        let category = getCategoryForBenefit(benefit)
        let icon = getIconForBenefit(benefit)
        
        cell.configure(with: benefit, category: category, icon: icon)
        return cell
    }
}

extension StoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let benefit = benefits[indexPath.row]
        showPurchaseAlert(for: benefit)
    }
    
    private func showPurchaseAlert(for benefit: Benefit) {
        let alert = UIAlertController(
            title: "Confirmar Compra",
            message: "Deseja trocar \(benefit.value) pontos por '\(benefit.name)'?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default) { _ in
            self.showSuccessAlert(for: benefit)
        })
        
        present(alert, animated: true)
    }
    
    private func showSuccessAlert(for benefit: Benefit) {
        let alert = UIAlertController(
            title: "Compra Realizada!",
            message: "Você trocou \(benefit.value) pontos por '\(benefit.name)'. Verifique seu email para mais detalhes.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - BenefitCell
class BenefitCell: UITableViewCell {
    static let identifier = "BenefitCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundTertiary
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.labelPrimary.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.tintColor = .white
        imageView.backgroundColor = .mainGreen
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primitiveWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .primitiveWhite
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .primitiveWhite
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .labelPrimary
        label.backgroundColor = .mainGreen
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -8),
            
            categoryLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            categoryLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            categoryLabel.widthAnchor.constraint(equalToConstant: 100),
            categoryLabel.heightAnchor.constraint(equalToConstant: 20),
            
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(with benefit: Benefit, category: String, icon: String) {
        nameLabel.text = benefit.name
        descriptionLabel.text = benefit.description
        valueLabel.text = "\(benefit.value) pts"
        categoryLabel.text = category
        iconImageView.image = UIImage(systemName: icon)
    }
}
