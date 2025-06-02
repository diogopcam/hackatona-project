//
//  StarRatingView.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//


import UIKit

class StarRatingView: UIStackView {
    var isEditable: Bool = true
    
    private lazy var stars: [UIButton] = []
    var rating: Int = 0 {
        didSet {
            updateStars()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStars()
    }
    
    private func setupStars() {
        self.axis = .horizontal
        self.alignment = .center
        self.distribution = .fillEqually
        self.spacing = 8
        
        for i in 1...5 {
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
            let image = UIImage(systemName: "star", withConfiguration: config)
            button.setImage(image, for: .normal)
            button.tintColor = .gray
            button.tag = i
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            stars.append(button)
            self.addArrangedSubview(button)
        }
    }
    
    @objc private func starTapped(_ sender: UIButton) {
        guard isEditable else { return }
        rating = sender.tag
    }
    
    private func updateStars() {
        for button in stars {
            let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
            if button.tag <= rating {
                button.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .normal)
                button.tintColor = .systemYellow
            } else {
                button.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
                button.tintColor = .gray
            }
        }
    }
    
    func setRating(_ rating: Int) {
        self.rating = rating
    }
}
