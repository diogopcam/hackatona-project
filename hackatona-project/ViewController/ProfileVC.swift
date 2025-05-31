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
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        label.textColor = .white
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Usuario"
        return label
    }()
    
    lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        let email = "Cargo"
        label.text = maskEmail(email)
        
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
    
    lazy var profileInformationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageStackView, userInfoStackView,
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.backgroundColor = .systemGray
        stackView.layer.cornerRadius = 13
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
            
            
            userInfoStackView.heightAnchor.constraint(equalToConstant: 58),
            userInfoStackView.topAnchor.constraint(equalTo: imageStackView.topAnchor, constant: 8),
            userInfoStackView.bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: -8),
            profileInformationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileInformationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileInformationStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            profileInformationStackView.heightAnchor.constraint(equalToConstant: 102),
            
            imageStackView.topAnchor.constraint(equalTo: profileInformationStackView.topAnchor, constant: 16),
            imageStackView.bottomAnchor.constraint(equalTo: profileInformationStackView.bottomAnchor, constant: -16),
            imageStackView.leadingAnchor.constraint(equalTo: profileInformationStackView.leadingAnchor, constant: 16),
            
            profileImageView.heightAnchor.constraint(equalToConstant: 52),
            profileImageView.widthAnchor.constraint(equalToConstant: 52),
           
        ])
        

        profileImageView.layer.cornerRadius = 26
        profileImageView.layer.masksToBounds = true
        
        
    }
    
    
}
