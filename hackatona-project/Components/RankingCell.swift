import UIKit

class RankingCell: UITableViewCell {
    static let identifier = "RankingCell"
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        imageView.backgroundColor = .mainGreen
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .labelPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pointsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .mainGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(name: String, points: Int, position: Int) {
        nameLabel.text = name
        pointsLabel.text = "\(points) pts"
        positionLabel.text = "\(position)"
        
        if name == "You" {
            containerView.backgroundColor = .mainGreen.withAlphaComponent(0.3)
        } else {
            containerView.backgroundColor = .backgroundSecondary
        }
    }
}

// MARK: - ViewCodeProtocol
extension RankingCell: ViewCodeProtocol {
    func addSubViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(positionLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(pointsLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            positionLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            positionLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            pointsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            pointsLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
    }
} 
