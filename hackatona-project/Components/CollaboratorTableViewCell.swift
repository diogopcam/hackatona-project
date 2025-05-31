//
//  CollaboratorTableViewCell.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import UIKit

class CollaboratorTableViewCell: UITableViewCell {
    static let identifier = "CollaboratorTableViewCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .mainGreen
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .mainGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        // Clean up any existing subviews
        avatarImageView.subviews.forEach { $0.removeFromSuperview() }
        
        if let imageURLString = imageURL, let url = URL(string: imageURLString) {
            // Show loading state with first letter while image loads
            let firstLetter = String(name.prefix(1)).uppercased()
            let label = UILabel()
            label.text = firstLetter
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.frame = avatarImageView.bounds
            avatarImageView.image = nil
            avatarImageView.addSubview(label)
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                      let data = data,
                      let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    // Clean up letter label when image loads
                    self.avatarImageView.subviews.forEach { $0.removeFromSuperview() }
                    self.avatarImageView.image = image
                }
            }.resume()
        } else {
            // If no image URL, display first letter of name
            let firstLetter = String(name.prefix(1)).uppercased()
            let label = UILabel()
            label.text = firstLetter
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.frame = avatarImageView.bounds
            avatarImageView.image = nil
            avatarImageView.addSubview(label)
        }
    }
}

extension CollaboratorTableViewCell: ViewCodeProtocol {
    func addSubViews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            avatarImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: 12
            ),
            nameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 20
            ),

            roleLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),
            roleLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 4
            ),
            roleLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            ),
        ])
    }
}
