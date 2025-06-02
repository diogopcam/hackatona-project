//
//  GenericTableViewHeader.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//

import UIKit

class GenericTableViewHeader: UIView {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .mainGreen
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        stack.backgroundColor = .backgroundSecondary
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(
        image: UIImage,
        text: String,
        button: UIButton? = nil,
        font: UIFont? = nil
    ) {
        super.init(frame: .zero)
        imageView.image = image
        titleLabel.text = text
        if let font {
            titleLabel.font = font
        }
        configureStack(with: button)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureStack(with button: UIButton?) {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)

        if let btn = button {
            let spacer = UIView()
            spacer.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(spacer)
            stackView.addArrangedSubview(btn)
            btn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                btn.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
}

extension GenericTableViewHeader: ViewCodeProtocol {
    func addSubViews() {
        addSubview(stackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
