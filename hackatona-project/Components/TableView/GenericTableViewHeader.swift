//
//  GenericTableViewHeader.swift
//  AvoTracker
//
//  Created by João Pedro Teixeira de Caralho on 14/05/25.
//

import UIKit

class GenericTableViewHeader: UIView {
    
    // MARK: Image
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .green
        return imageView
    }()
    
    
    // MARK: Title
    lazy var titleLabel = Components.getLabel(content: "", font: .systemFont(ofSize: 36, weight: .bold))
    
    
    // MARK: Stack
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    
    // MARK: Optional Button
    private var button: UIButton?
    
    
    // MARK: Scene
    init(image: UIImage, text: String, button: UIButton? = nil, font: UIFont? = nil, backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        imageView.image = image
        titleLabel.text = text
        titleLabel.font = font
        self.button = button
        
        self.backgroundColor = backgroundColor
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: View Code Protocol
extension GenericTableViewHeader: ViewCodeProtocol {
    func addSubViews() {
        addSubview(stackView)
        if let button = button {
            addSubview(button)
        }
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        if let button = button {
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: topAnchor),
                button.trailingAnchor.constraint(equalTo: trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
