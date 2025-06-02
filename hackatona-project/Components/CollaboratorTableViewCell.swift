//
//  CollaboratorTableViewCell.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import UIKit

class CollaboratorTableViewCell: UITableViewCell {
    static let identifier = "CollaboratorTableViewCell"

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = .mainGreen
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .mainGreen
        return label
    }()

    private lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()

    private lazy var labelsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, labelsStackView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(name: String, role: String, imageURL: String? = nil) {
        nameLabel.text = name
        roleLabel.text = role
        
        avatarImageView.subviews.forEach { $0.removeFromSuperview() }
        avatarImageView.image = nil

        let firstLetter = String(name.prefix(1)).uppercased()
        let placeholderLabel = UILabel()
        placeholderLabel.text = firstLetter
        placeholderLabel.font = .systemFont(ofSize: 20, weight: .bold)
        placeholderLabel.textColor = .labelPrimary
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor)
        ])

        if let imageURLString = imageURL, let url = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.avatarImageView.subviews.forEach { $0.removeFromSuperview() }
                    self.avatarImageView.image = image
                }
            }.resume()
        }
    }
}

extension CollaboratorTableViewCell: ViewCodeProtocol {
    func addSubViews() {
        contentView.addSubview(mainStackView)
        contentView.backgroundColor = .backgroundSecondary
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
