//
//  NamedTextField.swift
//  AvoTracker
//
//  Created by João Pedro Teixeira de Caralho on 13/05/25.
//
import UIKit

class NamedTextField: UIView {
    
    // MARK: Title
    lazy var titleLabel = Components.getLabel(content: "", font: .systemFont(ofSize: 16), textColor: .white)
    
    // MARK: Textfield
    lazy var textField = Components.getTextField()
    

    lazy var stack: UIStackView = {
        var stack = UIStackView(arrangedSubviews: [titleLabel, textField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    
    // MARK: Init
    init(title: String, placeholder: String, isPassword: Bool = false) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isPassword
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function
    func getText() -> String {
        return textField.text ?? ""
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
    
    var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    

    
}

// MARK: View Code Protocol
extension NamedTextField: ViewCodeProtocol {
    func addSubViews() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
