//
//  FoodTableIvewCellTableViewCell.swift
//  AvoTracker
//
//  Created by João Pedro Teixeira de Caralho on 15/05/25.
//
import UIKit

class FeedbackTableViewCell: UITableViewCell {
    
    // MARK: Reuse ID
    static let reuseIdentifier = "feedback-cell"
    
    // MARK: Name label
    lazy var nameLabel = Components.getLabel(content: "", font: .systemFont(ofSize: 17))
    
    // MARK: Stars label
    lazy var starsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    // MARK: Main stack
    lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, starsLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        return stack
    }()
    
    // MARK: Config
    func config(_ feedback: Feedback) {
        nameLabel.text = feedback.senderID
        starsLabel.text = String(repeating: "⭐️", count: feedback.stars)
    }
        
        // MARK: Init
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    
    // MARK: View Code Protocol
    extension FeedbackTableViewCell: ViewCodeProtocol {
        
        func addSubViews() {
            contentView.addSubview(mainStack)
        }
        
        func setupConstraints() {
            
            NSLayoutConstraint.activate([
                mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
                mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                mainStack.heightAnchor.constraint(equalToConstant: 72)
            ])
        }
    }
    
