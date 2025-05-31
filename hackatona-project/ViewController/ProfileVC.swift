//
//  ProfileViewController.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//
import UIKit





class ProfileViewController: UIViewController {
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.fill")!)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill")!)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var starsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.text = "4.7"
        return label
    }()
    
    lazy var starStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [starImageView, starsLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, starStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Full Name"
        return label
    }()
    
    lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
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
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        label.text = "Saldo: 100 pts"
        return label
    }()
    
    lazy var totalPointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        label.text = "Total: 1.670 pts"
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
    
    lazy var profileInformationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageStackView, userInfoStackView, pointsStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.backgroundColor = .systemGray6
        stackView.layer.cornerRadius = 13
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return stackView
    }()
    
    
    
    
    
    private func maskEmail(_ email: String) -> String {
        guard let atIndex = email.firstIndex(of: "@"), email.count >= 3 else {
            return email
        }
        
        let startIndex = email.startIndex
        let secondIndex = email.index(after: startIndex)
        let thirdIndex = email.index(after: secondIndex)
        
        let prefix = email[startIndex...secondIndex]
        let maskedLength = email.distance(from: thirdIndex, to: atIndex)
        let masked = String(repeating: "*", count: maskedLength)
        let domain = email[atIndex...]
        
        return "\(prefix)\(masked)\(domain)"
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    

}

extension ProfileViewController: ViewCodeProtocol {
    func addSubViews() {
        view.addSubview(profileInformationStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            profileInformationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileInformationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileInformationStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageStackView.heightAnchor.constraint(equalToConstant: 70),
            
            profileImageView.heightAnchor.constraint(equalToConstant: 52),
            profileImageView.widthAnchor.constraint(equalToConstant: 52),
            
            userInfoStackView.heightAnchor.constraint(equalToConstant: 58),
        ])

        profileImageView.layer.cornerRadius = 26
        profileImageView.layer.masksToBounds = true
        
        view.backgroundColor = .white
    }
    
    
}
