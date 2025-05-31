//
//  ProfileHeader.swift
//  hackatona-project
//
//  Created by Eduardo Camana on 31/05/25.
//

import UIKit

class ProfileHeader: UIView {

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill")!)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 21
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill")!)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = "4.7"
        return label
    }()
    
    lazy var starStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [starImageView, starsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, starStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.alignment = .leading
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Full Name"
        return label
    }()
    
    lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        label.text = "Role"
        return label
    }()
    
    lazy var userInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, roleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.text = "Saldo: \(GlobalData.balance)"
        return label
    }()
    
    lazy var totalPointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 17)
        label.text = "Total: \(GlobalData.totalPoints)"
        return label
    }()
    
    lazy var pointsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [balanceLabel, totalPointsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .trailing
        return stackView
    }()
    
    lazy var iconAndInfoStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [imageStackView, userInfoStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconAndInfoStackView, pointsStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 13
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        balanceLabel.text = "Saldo: \(GlobalData.balance)"
        totalPointsLabel.text = "Total: \(GlobalData.totalPoints)"
    }
}

extension ProfileHeader: ViewCodeProtocol {
    func addSubViews() {
        addSubview(contentStackView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageStackView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 42),
            profileImageView.widthAnchor.constraint(equalToConstant: 42),
            userInfoStackView.heightAnchor.constraint(equalToConstant: 58),
        ])
    }
}
