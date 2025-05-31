//
//  FoodTableIvewCellTableViewCell.swift
//  AvoTracker
//
//  Created by João Pedro Teixeira de Caralho on 15/05/25.
//
import UIKit

class FoodTableViewCell: UITableViewCell {
    
    // MARK: Reuse ID
    static let reuseIdentifier = "feedback-cell"
    
    // MARK: Title label
    lazy var titleLabel = Components.getLabel(content: "Feedback Title", font: Fonts.body)
    
    
    // MARK: Config
    func config(_ feedback: Food) {
        titleLabel.text = food.name
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
extension FoodTableViewCell: ViewCodeProtocol {
    func addSubviews() {
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}

