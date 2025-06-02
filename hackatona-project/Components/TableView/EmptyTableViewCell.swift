//
//  EmptyTableViewCell.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//
import UIKit

class EmptyTableViewCell: UITableViewCell {
    static let reuseIdentifier = "empty-cell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .labelPrimary
        label.textAlignment = .center
        
        return label
    }()

    lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [
            titleLabel, descriptionLabel,
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        stack.backgroundColor = .backgroundSecondary
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(
            top: 10,
            left: 40,
            bottom: 10,
            right: 40
        )
        return stack
    }()

    func config(_ mode: Int) {
        switch mode {
        case 0:
            titleLabel.text = "No feedback received"
            descriptionLabel.text = "No one has sent you feedback yet"
        case 1:
            titleLabel.text = "No feedback sent"
            descriptionLabel.text = "Send feedback to someone"
        default:
            titleLabel.text = ""
            descriptionLabel.text = ""
        }
    }

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

extension EmptyTableViewCell: ViewCodeProtocol {
    func addSubViews() {
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
