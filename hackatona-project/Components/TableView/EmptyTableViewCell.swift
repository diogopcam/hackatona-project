//
//  EmptyTableViewCell.swift
//  AvoTracker
//
//  Created by João Pedro Teixeira de Caralho on 19/05/25.
//
import UIKit

class EmptyTableViewCell: UITableViewCell {

    // MARK: Reuse ID
    static let reuseIdentifier = "empty-cell"

    // MARK: Title label
    lazy var titleLabel = Components.getLabel(
        content: "",
        font: Fonts.bodySemibold
    )

    // MARK: Description label
    lazy var descriptionLabel = Components.getLabel(
        content: "",
        font: Fonts.body,
        textColor: .labelsSecondary,
        alignment: .center
    )

    lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            titleLabel, descriptionLabel,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        stack.backgroundColor = .fillsTertiary
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(
            top: 10,
            left: 40,
            bottom: 10,
            right: 40
        )
        return stack
    }()

    // MARK: Config
    func config(_ mode: Int) {
        var auxTitle = ""
        var auxDescription = ""

        switch mode {
        case 0:
            auxTitle = "refeições registradas"
            auxDescription = "uma refeição no botão acima"
        case 1:
            auxTitle = "sintomas registrados"
            auxDescription = "um sintoma no botão acima"
        case 2:
            auxTitle = "alimentos em alerta"
            auxDescription = "refeições e sintomas"
        case 3:
            auxTitle = "refeições registradas"
            auxDescription = "uma refeição em Registros"
        case 4:
            auxTitle = "sintomas registrados"
            auxDescription = "um sintoma em Registros"
        case 5:
            auxTitle = "alimentos em alerta"
            auxDescription = "refeições e sintomas"
        default:
            auxTitle = ""
            auxDescription = ""
        }

        titleLabel.text = "Sem \(auxTitle)"
        descriptionLabel.text =
            "Adicione \(auxDescription) para visualizar os dados"
    }

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: View Code Protocol
extension EmptyTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        contentView.addSubview(stack)
    }

    func setupConstraints() {

        NSLayoutConstraint.activate([

            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stack.heightAnchor.constraint(equalToConstant: 95),

        ])
    }
}
